From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH #upstream-fixes] libata: Add transport class for libata
Date: Tue, 19 Aug 2008 13:34:04 +0200
Message-ID: <48AAAFAC.9050502@s5r6.in-berlin.de>
References: <e7510f760808182131q1bd3aa4bp694ebff75b612995@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <e7510f760808182131q1bd3aa4bp694ebff75b612995@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Gwendal Grignou <gwendal@google.com>
Cc: IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Gwendal Grignou wrote:
> This patch adds objects for accessing libata objects from user space:
> - ata_port class: one per ATA port
> - ata_link class: one per ATA port or 15 for SATA Port Multiplier
> - ata_device class: up to 2 for PATA link, usually one for SATA.

Two outsider questions:

You are adding a userspace interface.  What are the stability commitments?

Could you make it configurable, so that people who don't need this
interface can build the kernel without it?
-- 
Stefan Richter
-=====-==--- =--- =--==
http://arcgraph.de/sr/
