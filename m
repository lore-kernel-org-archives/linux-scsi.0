From: syzbot <syzbot+19a9f729f05272857487@syzkaller.appspotmail.com>
Subject: Re: KASAN: use-after-free Read in hci_cmd_timeout
Date: Wed, 03 Jul 2019 11:26:00 -0700
Message-ID: <00000000000041ac74058ccafe0d@google.com>
References: <00000000000035c756058848954a@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <00000000000035c756058848954a@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: chaitra.basappa@broadcom.com, davem@davemloft.net, jejb@linux.vnet.ibm.com, johan.hedberg@gmail.com, linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, marcel@holtmann.org, martin.petersen@oracle.com, mpt-fusionlinux.pdl@broadcom.com, netdev@vger.kernel.org, sathya.prakash@broadcom.com, suganath-prabu.subramani@broadcom.com, syzkaller-bugs@googlegroups.com
List-Id: linux-scsi@vger.kernel.org

syzbot has bisected this bug to:

commit ff92b9dd9268507e23fc10cc4341626cef50367c
Author: Suganath Prabu <suganath-prabu.subramani@broadcom.com>
Date:   Thu Oct 25 14:03:40 2018 +0000

     scsi: mpt3sas: Update MPI headers to support Aero controllers

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=130ac8dda00000
start commit:   eca94432 Bluetooth: Fix faulty expression for minimum encr..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=108ac8dda00000
console output: https://syzkaller.appspot.com/x/log.txt?x=170ac8dda00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f6451f0da3d42d53
dashboard link: https://syzkaller.appspot.com/bug?extid=19a9f729f05272857487
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=125b7999a00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=176deefba00000

Reported-by: syzbot+19a9f729f05272857487@syzkaller.appspotmail.com
Fixes: ff92b9dd9268 ("scsi: mpt3sas: Update MPI headers to support Aero  
controllers")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
