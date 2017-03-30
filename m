From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2] scsi/bfa: use designated initializers
Date: Thu, 30 Mar 2017 10:18:55 +0200
Message-ID: <20170330081855.GA11344@lst.de>
References: <20170329205509.GA39525@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170329205509.GA39525@beast>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Mar 29, 2017 at 01:55:09PM -0700, Kees Cook wrote:
> Prepare to mark sensitive kernel structures for randomization by making
> sure they're using designated initializers. These were identified during
> allyesconfig builds of x86, arm, and arm64, with most initializer fixes
> extracted from grsecurity.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> This has been updated now that struct bfa_fcs_mod_s was dropped.

Can you also add designated array initializers for __port_action while
you're at it?
