From: Joao Pinto <Joao.Pinto@synopsys.com>
Subject: UFS API in the kernel
Date: Thu, 22 Sep 2016 16:21:05 +0100
Message-ID: <c6a8636a-98e6-61d0-ff4b-350fb3869699@synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi!

I am designing an application that has the goal to be an utility for Unipro and
UFS testing purposes. This application is going to run on top of a recent Linux
Kernel containing the new UFS stack (including the new DWC drivers).

I am considering doing the following:
a) Create a new config item called CONFIG_UFS_CHARDEV which is going to create a
char device responsible to make some IOCTL available for user-space applications
b) Create a linux/ufs.h header file that contains data structures declarations
that will be needed in user-space applications

Could you please advise me about what the correct approach should be to make it
as standard as possible and usable in the future?

Thank you very much for your help!

regards,
Joao
