From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: PATCH for disabling write cache on SATA drives
Date: Tue, 29 Jun 2004 23:55:07 -0400
Sender: linux-ide-owner@vger.kernel.org
Message-ID: <40E2399B.8050507@pobox.com>
References: <1F6D1D1660975A4887628A011443A1BC07734C05@uswaumsx13medge.med.ge.com> <40E22D74.4000600@pobox.com> <Pine.LNX.4.60.0406292124280.11993@xmission.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.60.0406292124280.11993@xmission.xmission.com>
To: "J. Scott Edwards" <sedwards@xmission.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

J. Scott Edwards wrote:
> I have already given this some thought.  I agree that re-issuing the 
> IDENTIFY DEVICE would be difficult, but I would feel more confident that 
> the SET FEATURES actually worked if it was read back.  Maybe I could do 
> it in two stages, do the easy one first and just update the cached data. 
> Then later wrestle with re-issuing the IDENTIFY DEVICE?


I would definitely suggest two stages, as I haven't yet added the 
infrastructure to re-issue commands (such as IDENTIFY DEVICE) yet :)

	Jeff


