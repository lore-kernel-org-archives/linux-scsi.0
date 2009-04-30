From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCHSET] block,scsi,libata: implement alt_size
Date: Thu, 30 Apr 2009 16:00:09 -0400
Message-ID: <49FA0349.3090706@garzik.org>
References: <1233456951-992-1-git-send-email-tj@kernel.org> <49F902CF.7080307@garzik.org> <49F903DD.8040707@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <49F903DD.8040707@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, Mauelshagen@RedHat.com, dm-devel@RedHat.com
List-Id: linux-scsi@vger.kernel.org

Tejun Heo wrote:
> Hello,
> 
> Jeff Garzik wrote:
>> <shrug>  I suppose...
>>
>> It just seems like a nasty hack, but unfortunately I don't see
>> anyone stepping up to do it properly -- with a DM device
>> automatically layered on top that splits the device into separate
>> regions: one block device for the 'regular' area, and one for the
>> HPA.
> 
> Isn't that more hacky?  I don't know.  All that dm needs to know is
> the location of the metadata which is located w.r.t. the end of the
> device which might be at a different location if BIOS tried to pull
> silly stunts.  So, exporting the size BIOS might have used seems like
> a straight forward solution to me.

"<shrug> I suppose" is basically a reluctant ack, in the absence of 
other solutions :)


