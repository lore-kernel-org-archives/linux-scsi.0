From: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH v2] Add Marvell UMI driver
Date: Mon, 9 May 2011 12:20:51 -0700
Message-ID: <20110509122051.33f1672f@jbarnes-desktop>
References: <Message-Id>
	<1304943577-2876-1-git-send-email-jianyunff@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1304943577-2876-1-git-send-email-jianyunff@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jianyun Li <jianyunff@gmail.com>
Cc: James.Bottomley@suse.de, Jianyun Li <jyli@marvell.com>, "open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, "open list:PCI SUBSYSTEM" <linux-pci@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon,  9 May 2011 20:19:33 +0800
Jianyun Li <jianyunff@gmail.com> wrote:

> 	The Marvell Universal Message Interface (UMI) defines a messaging
> interface between host and Marvell products (Plato, for example). It
> considers situations of limited system resource and optimized system
> performance.
> 	UMI driver translates host request to message and sends message
> to FW via UMI, FW receives message and processes it, then sends response
> to UMI driver.
> 	FW generates an interrupt when it needs to send information or
> response to UMI driver
> 

Unless you're using the PCI ID outside of this driver, you can just put
it in your header file rather than pci_ids.h, which is meant for IDs
that are shared between modules.

-- 
Jesse Barnes, Intel Open Source Technology Center
