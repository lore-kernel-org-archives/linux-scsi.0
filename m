From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 1/2] fdomain: Resurrect fdomain and fdomain_cs drivers
Date: Tue, 9 Apr 2019 03:55:28 -0700
Message-ID: <20190409105528.GA12779@infradead.org>
References: <20190407185617.8467-1-linux@zary.sk>
 <20190407185617.8467-2-linux@zary.sk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190407185617.8467-2-linux@zary.sk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ondrej Zary <linux@zary.sk>
Cc: Rik Faith <faith@cs.unc.edu>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, Apr 07, 2019 at 08:56:16PM +0200, Ondrej Zary wrote:
> This reverts commit e184f2bf4d9f1a3c612a8c1d67e73e9cf8ab5ab9.
> It does not compile but following patches will fix that.

Please just resurrect it as a proper driver that fits modern standards,
including the coding style.  To make your life much easier I'd suggest
you do that for the PCI devices only and leave the rest behind.
