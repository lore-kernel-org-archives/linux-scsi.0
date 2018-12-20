From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: [PATCH 20/41] scsi: isci: request: mark expected switch
 fall-through
Date: Thu, 20 Dec 2018 09:51:29 +0100
Message-ID: <03eab112-da42-628b-d6cd-dccb981bf8be@intel.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
 <318fe89a188e4783b7d4cf982d365160@fmsmsx105.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <318fe89a188e4783b7d4cf982d365160@fmsmsx105.amr.corp.intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>, intel-linux-scu <intel-linux-scu@intel.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 11/28/18 5:30 AM, Gustavo A. R. Silva wrote:
> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
> where we are expecting to fall through.
> 
> Notice that, in this particular case, a dash is added as a token in
> order to separate the "Fall through" annotation from the rest of the
> comment on the same line, which is what GCC is expecting to find.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Acked-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
