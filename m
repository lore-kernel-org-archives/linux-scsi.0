From: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] pci: enable MSI on 8132
Date: Sun, 22 Feb 2009 13:45:52 -0800
Message-ID: <49A1C790.1030303@kernel.org>
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm> <200902221308.55053.prakash@punnoor.de> <m1iqn2ein5.fsf@fess.ebiederm.org> <200902221617.21621.prakash@punnoor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <200902221617.21621.prakash@punnoor.de>
Sender: linux-pci-owner@vger.kernel.org
To: Prakash Punnoor <prakash@punnoor.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Robert Hancock <hancockrwd@gmail.com>, Jesse Barnes <jbarnes@virtuousgeek.org>, Andrew Morton <akpm@linux-foundation.org>, david@lang.hm, Matthew Wilcox <matthew@wil.cx>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, DL-MPTFusionLinux@lsi.com, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

your system have one HT chain c51->mcp51

BIOS enabled HT-MSI on c51, and hda ...
it seems pci quirks should not be used enable HT MSI on mcp51 again...

YH
