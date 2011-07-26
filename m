From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: Slower write performance in RHEL6
Date: Tue, 26 Jul 2011 07:38:20 -0400
Message-ID: <4E2EA72C.7030109@redhat.com>
References: <CAMYVA_nrqA_GFnRXFFUJp=NYfYLy7z6gC7Tur8EQmgOEKvqf4Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58131 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753299Ab1GZLiY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Jul 2011 07:38:24 -0400
In-Reply-To: <CAMYVA_nrqA_GFnRXFFUJp=NYfYLy7z6gC7Tur8EQmgOEKvqf4Q@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Li Liu <li.liu0637@gmail.com>
Cc: linux-scsi@vger.kernel.org

On 07/26/2011 07:22 AM, Li Liu wrote:
> Dear all,
>
>      In RHEL6(linux-2.6.32-71.el6), I added some codes in
> scsi_softirq_done to check the result of execute scsi commands:
> WRITE_6, WRITE_10, WRITE_12, WRITE_16 when I executed "dd if=/dev/zero
> of=/dev/xda bs=64k count=10000". I found a lot of write error messages
> in scsi_softirq_done, the disposition(variable) was ADD_TO_MLQUEUE and
> the speed was 78MB/s.
>      Then I changed MPT_SCSI_CMD_PER_DEV_HIGH from 64 to 32 in
> mptscsih_change_queue_depth, the speed was 140MB/s and none error
> messages.
>      * /dev/xda is a scsi disk.
>      * the scsi host is LSI1064E.
>      * MPT_SCSI_CMD_PER_DEV_HIGH will be assigned to blk_queue_tag->max_depth.
>
>      My questions are:
>      Is the TCQ depth limited by hard disk, how can I get the limited?
>      Why the speed was drop to 78MB/s when MPT_SCSI_CMD_PER_DEV_HIGH was 64?
>      Could I change MPT_SCSI_CMD_PER_DEV_HIGH to 32 or 16 or 8, Will it
> cause any problem?
>
>      Thanks for any ideas.
>
> Thanks,
> Alex Liu

When you have a vendor specific issues, it is probably best to raise a ticket 
with the vendor's support organization....

Thanks!

Ric


