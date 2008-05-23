From: "Laurent Wandrebeck" <l.wandrebeck@gmail.com>
Subject: Re: pci_set_mwi and 3ware controllers
Date: Fri, 23 May 2008 21:56:58 +0200
Message-ID: <fc593b510805231256l296729dcydbb190aa750b3ac7@mail.gmail.com>
References: <fc593b510805230533lf28171fp24459bf09321500e@mail.gmail.com>
	 <b1bc6a000805231239i34731c79h3b29fad00b1e8eb1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.242]:53393 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757516AbYEWT50 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 May 2008 15:57:26 -0400
Received: by an-out-0708.google.com with SMTP id d40so177701and.103
        for <linux-scsi@vger.kernel.org>; Fri, 23 May 2008 12:57:22 -0700 (PDT)
In-Reply-To: <b1bc6a000805231239i34731c79h3b29fad00b1e8eb1@mail.gmail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adam radford <aradford@gmail.com>
Cc: Tony Battersby <tonyb@cybernetics.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>

2008/5/23 adam radford <aradford@gmail.com>:
> On Fri, May 23, 2008 at 5:33 AM, Laurent Wandrebeck
> <l.wandrebeck@gmail.com> wrote:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=1e6c38cec08f88b0df88a34e80f15492cace74e9
>> patch.
>> I have at work a mobo (with 3ware 9650) that doesn't enable mwi by
>> default, and running CentOS 5.1 x86_64 (2.6.18 based).
>> I can confirm that putting pci_set_mwi just after pci_set_master gives
>
> The 3w-9xxx driver in 2.6.25 already calls 'pci_try_set_mwi(pdev)'.
Agreed. But RHEL/Centos doesn't update "their" kernel as much as the main tree.
And, I'm not really willing to have a much different and less tested
kernel (in RHEL/CetnOS context, that is) as the one provided by
default.
Anyway, I was just willing to let you know that the fix works fine
with others than 9550 controllers ;)
Regards,
Laurent.
