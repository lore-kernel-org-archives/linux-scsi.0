From: Phil Thompson <philt@4bridgeworks.com>
Subject: Broken NVRAM Detection in sym53c8xx Driver
Date: Tue, 13 Apr 2004 11:53:45 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <C18BA5DDB58DD511BD0700C0DF0DD45028B294@NTSERVER4>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhost.digitalinterfacesltd.com ([62.69.87.37]:64269 "EHLO
	ntserver4.diluk.co.uk") by vger.kernel.org with ESMTP
	id S263540AbUDMKxs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Apr 2004 06:53:48 -0400
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

Apologies if this is fixed in a later version - I'm using the sym-2.1.17a
version of the driver that's in Linux 2.4.25.

The NVRAM detection code in sym_nvram.c is broken for big endian CPUs. The
NVRAM is in little endian format, but the code doesn't do the necessary
conversions for fields bigger than a byte.

Phil
