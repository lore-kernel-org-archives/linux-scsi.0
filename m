From: Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: [PATCH 1/8] aha152x: rename the PCMCIA define
Date: Mon, 15 Oct 2018 15:57:27 -0500
Message-ID: <20181015205727.GD5906@bhelgaas-glaptop.roam.corp.google.com>
References: <20181013151016.31674-1-hch@lst.de>
 <20181013151016.31674-2-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181013151016.31674-2-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>, Matt Porter <mporter@kernel.crashing.org>, Alexandre Bounine <alex.bou9@gmail.com>, Dominik Brodowski <linux@dominikbrodowski.net>, linux-kbuild@vger.kernel.org, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Oct 13, 2018 at 05:10:09PM +0200, Christoph Hellwig wrote:
> We plan to enable building the pcmcia core and drivers, and the
> non-prefixed PCMCIA name clashes with some arch headers.

In the followup PCMCIA patch, you capitalized "PCMCIA core".
