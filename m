From: Sedat Dilek <sedat.dilek@gmail.com>
Subject: Re: [PATCH] fcoe: make use of fip_mode enum complete
Date: Mon, 11 Feb 2019 09:59:38 +0100
Message-ID: <CA+icZUWPw3tzKAKAt=rLv09nPCwXVbc2h=Thb-5EOxc7Jx60fQ@mail.gmail.com>
Reply-To: sedat.dilek@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Cc: Hannes Reinecke" <hare@suse.de>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, QLogic-Storage-Upstream@qlogic.com, "Martin K . Petersen" <martin.petersen@oracle.com>, Johannes Thumshirn <jth@kernel.org>, QLogic-Storage-Upstream@cavium.com, Nick Desaulniers <ndesaulniers@google.com>
List-Id: linux-scsi@vger.kernel.org

Hi Lukas,

I have tested your patch with LLVM/Clang from Git (will get version 9)
with (RFC) asm-goto support.

I was able to build with CONFIG_FCOE=m and CONFIG_LIBFCOE=m and boot
on bare metal.

Feel free to add my...

     Tested-by: Sedat Dilek <sedat.dilek@gmail.com>

If you want to send out a v2 please feel free to add the following Link.

     Link: https://github.com/ClangBuiltLinux/linux/issues/151
("-Wenum-conversion in drivers/scsi/fcoe/fcoe{_ctlr,_transport}.c")

Thanks.

Regards,
- Sedat -
