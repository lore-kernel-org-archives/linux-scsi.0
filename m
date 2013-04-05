From: Vijay Chauhan <kernel.vijay@gmail.com>
Subject: [OT] LDD3 Query
Date: Fri, 5 Apr 2013 12:17:54 +0530
Message-ID: <CAJ61zBAP3E6bSaKSm=qwxnMyY_BBkA9W=kOMg-QSv90wJc=iTw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-pci-owner@vger.kernel.org>
Sender: linux-pci-owner@vger.kernel.org
To: linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

I am new to Linux Device Driver and reading LDD3.

It mentions that the disadvantage of dynamic major number allocation
is that you can=92t create the device nodes in
advance, because the major number assigned to your module will vary.

To solve this problem, it says that create a script to invoke insmod
and after calling insmod, reads /proc/devices in order to create the
special file(s).

My question is, is there no way to do it inside the module? How other
modules does?

---
Vijay
