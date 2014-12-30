From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] drivers: scsi: megaraid: Add
 "megaraid_sas_internal.h" for internal shared functions using
Date: Tue, 30 Dec 2014 04:45:11 -0800
Message-ID: <20141230124511.GB24088@infradead.org>
References: <548DB542.7000400@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <548DB542.7000400@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: megaraidlinux@lsi.com, JBottomley@parallels.com, Sumit Saxena <sumit.saxena@avagotech.com>, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Dec 15, 2014 at 12:05:22AM +0800, Chen Gang wrote:
> For shared inline functions crossed source files, better to let it as
> "static inline" in a header file. For extern functions, better to
> declare them in header file.


This one doesn't apply.
