From: "Julian Calaby" <julian.calaby@gmail.com>
Subject: Re: scsi problem with usb
Date: Fri, 18 Aug 2006 22:06:14 +1000
Message-ID: <646765f40608180506x56854c84h1925066cd7729fc0@mail.gmail.com>
References: <000201c6bf83$fc6200e0$802cc70a@dlh.st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.177]:29354 "EHLO
	py-out-1112.google.com") by vger.kernel.org with ESMTP
	id S932408AbWHRMGQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Aug 2006 08:06:16 -0400
Received: by py-out-1112.google.com with SMTP id n25so1053138pyg
        for <linux-scsi@vger.kernel.org>; Fri, 18 Aug 2006 05:06:15 -0700 (PDT)
In-Reply-To: <000201c6bf83$fc6200e0$802cc70a@dlh.st.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Manish RATHI <manish.rathi@st.com>
Cc: linux-scsi@vger.kernel.org

On 8/14/06, Manish RATHI <manish.rathi@st.com> wrote:
> However when I try to mount by
> Mount -t vfat /dev/sda /mnt/pendrive then
> I get error "Mounting /dev/sda on /mems failed: No such device" I tried it on sdb and sdc as well but it's not mounted.
>
> I also tried to run fdisk /dev/sda but same type of error appears.

Try mounting using "/dev/sda1", rather than "/dev/sda".

The device "sda" is the *entire* disk, "sda1" is the first partition
on it - this will contain your data.

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
