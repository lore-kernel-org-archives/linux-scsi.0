From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2] scsi/bfa: use designated initializers
Date: Thu, 13 Apr 2017 09:08:55 +0200
Message-ID: <20170413070855.GB24944@lst.de>
References: <20170329205509.GA39525@beast> <20170330081855.GA11344@lst.de> <CAGXu5jJ+9nm+Ojxfkc7z=y1=arSCh8Ye=aTXbvZHQwOwcrFgLA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGXu5jJ+9nm+Ojxfkc7z=y1=arSCh8Ye=aTXbvZHQwOwcrFgLA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Christoph Hellwig <hch@lst.de>, LKML <linux-kernel@vger.kernel.org>, Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Apr 12, 2017 at 05:21:20PM -0700, Kees Cook wrote:
> Hrm? This is what the patch already does. It adds them for both
> __port_action and struct bfa_module_s.

For __port_action it only uses designated initializers for the
structures in the array, not the array itself.
