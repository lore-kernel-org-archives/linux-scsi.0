From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH v3 0/4] Patchset to use PCLMULQDQ to accelerate
 CRC-T10DIF checksum computation
Date: Mon, 06 May 2013 18:12:52 -0700
Message-ID: <1367889172.27102.261.camel@schen9-DESK>
References: <cover.1367436101.git.tim.c.chen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <cover.1367436101.git.tim.c.chen@linux.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "David S. Miller" <davem@davemloft.net>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Matthew Wilcox <willy@linux.intel.com>, Jim Kukunas <james.t.kukunas@linux.intel.com>, Keith Busch <keith.busch@intel.com>, Erdinc Ozturk <erdinc.ozturk@intel.com>, Vinodh Gopal <vinodh.gopal@intel.com>, James Guilford <james.guilford@intel.com>, Wajdi Feghali <wajdi.k.feghali@intel.com>, Jussi Kivilinna <jussi.kivilinna@iki.fi>, linux-kernel <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2013-05-01 at 12:52 -0700, Tim Chen wrote:
> Currently the CRC-T10DIF checksum is computed using a generic table lookup
> algorithm.  By switching the checksum to PCLMULQDQ based computation,
> we can speedup the computation by 8x for checksumming 512 bytes and
> even more for larger buffer size.  This will improve performance of SCSI
> drivers turning on the CRC-T10IDF checksum.  In our SSD based experiments,
> we have seen increase disk throughput by 3.5x with T10DIF for 512 byte
> block size.
> 
> This patch set provides the x86_64 routine using PCLMULQDQ instruction
> and switches the crc_t10dif library function to use the faster PCLMULQDQ
> based routine when available.
> 
> Tim
> 
> v3
> 1. Update the crct10dif crypto transform used in the crct10dif library in a safe way.
> 2. Load the accelerated t10dif transform for the x86_64 cpus that support it.
> 3. Added generic crct10dif crypto transform.
> 

Herbert,

Any feedback on this updated patchset?  Thanks.

Tim
