From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] cdrom: Make device operations read-only
Date: Tue, 14 Feb 2017 08:30:25 -0700
Message-ID: <d82598ae-122b-4a80-4aec-e0f47e274e5b@kernel.dk>
References: <20170214002526.GA124769@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20170214002526.GA124769@beast>
Sender: linux-doc-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>, Tim Waugh <tim@cyberelk.net>, Borislav Petkov <bp@alien8.de>, "David S. Miller" <davem@davemloft.net>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-doc@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, kernel-hardening@lists.openwall.com
List-Id: linux-scsi@vger.kernel.org

On 02/13/2017 05:25 PM, Kees Cook wrote:
> Since function tables are a common target for attackers, it's best to keep
> them in read-only memory. As such, this makes the CDROM device ops tables
> const. This drops additionally n_minors, since it isn't used meaningfully,
> and sets the only user of cdrom_dummy_generic_packet explicitly so the
> variables can all be const.

Agree, it's a good change. Applied for 4.11.

-- 
Jens Axboe

