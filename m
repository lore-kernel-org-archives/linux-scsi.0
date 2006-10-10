From: "adam radford" <aradford@gmail.com>
Subject: Re: Frozen system even with Raid 5
Date: Tue, 10 Oct 2006 16:26:19 -0700
Message-ID: <b1bc6a000610101626y1730dfcby35a6ecdbc72b978b@mail.gmail.com>
References: <452C2A60.2070300@rapidforum.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:26597 "EHLO
	nf-out-0910.google.com") by vger.kernel.org with ESMTP
	id S1030644AbWJJX0V (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Oct 2006 19:26:21 -0400
Received: by nf-out-0910.google.com with SMTP id m18so444209nfc
        for <linux-scsi@vger.kernel.org>; Tue, 10 Oct 2006 16:26:20 -0700 (PDT)
In-Reply-To: <452C2A60.2070300@rapidforum.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christian Schmid <webmaster@rapidforum.com>
Cc: linuxraid@amcc.com, linux-scsi@vger.kernel.org

Christian,

Make sure you are running the latest 3ware firmware.  After that, contact
3ware/AMCC support if you still see any issues.

-Adam

On 10/10/06, Christian Schmid <webmaster@rapidforum.com> wrote:
> Hello.
>
> We are right now having a 360 TB Raid-system with 3-Ware controllers. Unfortunately there are 2 ways
> a disk can fail: A complete sudden fail, which results in a immediate shutdown of the disk, causing
> the array to continue in degraded mode (raid5), and the soft-fail, which results in a complete hang
> of the system, the system always prints errors of timeout sending command, card was resetted. A
> hard-remove of the drive clears the problem, but I dont think thats supposed to be that way, is it?
> The warnings below keep printed for hours, until the drive is removed. In this time the IOs hang.
>
> Oct 10 23:41:19 kernel: [2850624.586613] sd 0:0:4:0: WARNING: (0x06:0x002C): Command (0x28) timed
> out, resetting card.
> Oct 10 23:41:33 kernel: [2850638.425847] 3w-9xxx: scsi0: AEN: INFO (0x04:0x005E): Cache synchronized
> after power fail:unit=0.
> Oct 10 23:41:33 kernel: [2850638.545663] 3w-9xxx: scsi0: AEN: INFO (0x04:0x005E): Cache synchronized
> after power fail:unit=1.
> Oct 10 23:41:33 kernel: [2850638.665481] 3w-9xxx: scsi0: AEN: INFO (0x04:0x005E): Cache synchronized
> after power fail:unit=2.
> Oct 10 23:41:33 kernel: [2850638.785296] 3w-9xxx: scsi0: AEN: INFO (0x04:0x005E): Cache synchronized
> after power fail:unit=3.
> Oct 10 23:41:33 kernel: [2850638.905123] 3w-9xxx: scsi0: AEN: INFO (0x04:0x005E): Cache synchronized
> after power fail:unit=4.
> Oct 10 23:41:33 kernel: [2850639.024934] 3w-9xxx: scsi0: AEN: INFO (0x04:0x005E): Cache synchronized
> after power fail:unit=5.
> Oct 10 23:41:33 kernel: [2850639.144759] 3w-9xxx: scsi0: AEN: INFO (0x04:0x005E): Cache synchronized
> after power fail:unit=6.
> Oct 10 23:41:34 kernel: [2850639.264575] 3w-9xxx: scsi0: AEN: INFO (0x04:0x005E): Cache synchronized
> after power fail:unit=7.
>
> Linux 2.6.17.11 vanilla.
>
> Regards,
> Chris
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
