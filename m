From: "Dorau, Lukasz" <lukasz.dorau@intel.com>
Subject: 4 isci patches from isci-for-3.6 tag?
Date: Tue, 11 Sep 2012 12:29:29 +0000
Message-ID: <D9FFE20C522965449E182ACE73889AEB19007E46@IRSMSX102.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:34770 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957Ab2IKMbk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Sep 2012 08:31:40 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@Parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Danecki, Jacek" <jacek.danecki@intel.com>, "Patelczyk, Maciej" <maciej.patelczyk@intel.com>

Hi James

What are you going to do with the following four ISCI patches from isci-for-3.6 tag?:

6734092e66011def7875bd67beef889d0fee1cc9    isci: add a couple __iomem annotations
67787c330762eb884bf8c169fe942263d55ec162    isci: make function declaration match implementation
a90037560588e51b3e98b49537799137cbfda17d  isci: fix COMSAS negation timout workaround for WD SAS drives
6d70a74ffd616073a68ae0974d98819bfa8e6da6   isci: fix isci_pci_probe() generates warning on efi failure path
(by: Dan Carpenter, Dave Maurer and Dan Williams)

We hope they will get to the upstream kernel soon...

Regards,
Lukasz


