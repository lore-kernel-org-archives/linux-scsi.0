From: Rob Landley <rob@landley.net>
Subject: Scsi on sparc build break in 2.6.23.
Date: Thu, 11 Oct 2007 05:52:48 -0500
Message-ID: <200710110552.49129.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:58446
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751419AbXJKKwx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Oct 2007 06:52:53 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org

CONFIG_SCSI_SUNESP=y breaks the build in 2.6.23:

  LD      vmlinux
`scsi_esp_unregister' referenced in section `__ksymtab' of drivers/built-in.o: 
defined in discarded section `.exit.text' of drivers/built-in.o
make: *** [vmlinux] Error 1

Do you need my full .config to reproduce this?

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
