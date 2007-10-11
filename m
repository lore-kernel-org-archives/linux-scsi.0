From: "saeed bishara" <saeed.bishara@gmail.com>
Subject: question about scsi hotswap
Date: Thu, 11 Oct 2007 16:47:50 +0200
Message-ID: <c70ff3ad0710110747i38265247m312a3f09cae6d19d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.228]:8353 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579AbXJKOrw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Oct 2007 10:47:52 -0400
Received: by nz-out-0506.google.com with SMTP id s18so449217nze
        for <linux-scsi@vger.kernel.org>; Thu, 11 Oct 2007 07:47:51 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,
   the kernel behavior regarding scsi hotswap when the device is used
is not uniform, assume that one disk (sda) is connected to hba, and
this disk is part of a raid array. now if I do disconnect then connect
the same drive again to the same port, then the disk is detected as
new disk (sdb), but the next time I do disconnect and connect, then I
got an error message saying:
kobject_add failed for 1:0:0:0 with -EEXIST, don't try to register
things with the same name in the same directory.
also, the disk is not recognized!. and the same results are got when
doing farther disconnects.

my question is, why the Linux treats the first disconnect/connect differently!

saeed
