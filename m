From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [patch 16/26] hptiop: avoid buffer overflow when returning sense data
Date: Mon, 19 Nov 2007 11:38:35 -0700
Message-ID: <20071119183835.GE12494@parisc-linux.org>
References: <20071119181438.617190424@mini.kroah.org> <20071119181912.GQ15425@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753436AbXKSSit@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20071119181912.GQ15425@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, James.Bottomley@steeleye.com, Justin Forbes <jmforbes@linuxtx.org>, Zwane Mwaikambo <zwane@arm.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>, Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>, Chris Wedgwood <reviews@ml.cw.f00f.org>, Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>, Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org, akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, linux@highpoint-tech.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Nov 19, 2007 at 10:19:12AM -0800, Greg Kroah-Hartman wrote:
> 
> 2.6.22-stable review patch.  If anyone has any objections, please let us
> know.

Makes sense to backport this.

Acked-by: Matthew Wilcox <willy@linux.intel.com>

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
