From: Christoph Hellwig <hch@infradead.org>
Subject: Re: kernel BUG at drivers/scsi/scsi_lib.c:1096!
Date: Thu, 19 Nov 2015 00:23:25 -0800
Message-ID: <20151119082325.GA11419@infradead.org>
References: <1447838334.1564.2.camel@ellerman.id.au>
 <1447855399.3974.24.camel@redhat.com>
 <1447894964.15206.0.camel@ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1447894964.15206.0.camel@ellerman.id.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mark Salter <msalter@redhat.com>, "James E. J. Bottomley" <JBottomley@odin.com>, brking <brking@us.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

It's pretty much guaranteed a block layer bug, most likely in the
merge bios to request infrastucture where we don't obey the merging
limits properly.

Does either of you have a known good and first known bad kernel?
