From: "J. Scott Edwards" <sedwards@xmission.com>
Subject: Re: PATCH for disabling write cache on SATA drives
Date: Tue, 29 Jun 2004 21:47:38 -0600 (MDT)
Sender: linux-ide-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.60.0406292124280.11993@xmission.xmission.com>
References: <1F6D1D1660975A4887628A011443A1BC07734C05@uswaumsx13medge.med.ge.com>
 <40E22D74.4000600@pobox.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <40E22D74.4000600@pobox.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Jeff Garzik wrote:

>
> Basically, it involves the translation of MODE SELECT, something I've been 
> meaning to add, but is low priority.  If you wanted to work on that, that 
> would be quite useful.

This is what I did, but now I'm not sure if I still have the code.  We had 
a couple of discs get trashed during testing.  I hope the code wasn't on 
one of them. ;-)  I can probably do it again anyway.

> The following is a proposal for translating ATA to SCSI:
> http://www.t10.org/ftp/t10/document.04/04-196r0.pdf
>
> In that proposal, it describes the use of MODE SELECT Caching Mode Page (8h).

I will give it a look, some nice bedtime reading :)

> Note that, in addition to actually issuing the SET FEATURES command, to 
> disable/enable writeback caching, you must update libata's internal copy of 
> the IDENTIFY DEVICE page.  This involves either re-issuing IDENTIFY DEVICE 
> (difficult), or simply updating the 'enabled' bit in the internally cached 
> data (easy).
>

I have already given this some thought.  I agree that re-issuing the 
IDENTIFY DEVICE would be difficult, but I would feel more confident that 
the SET FEATURES actually worked if it was read back.  Maybe I could do it 
in two stages, do the easy one first and just update the cached data. 
Then later wrestle with re-issuing the IDENTIFY DEVICE?

If I'm not installing my server this weekend I will buy a SATA drive and 
take a shot at it again.  If I end up installing the server this weekend 
it will be a couple of weeks before I will have time (we are moving).

Thanks
   -Scott


