From: Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH 41/41] scsi: xen-scsifront: mark expected switch
 fall-through
Date: Wed, 28 Nov 2018 07:03:02 +0100
Message-ID: <a17db312-3e7c-113b-a8a1-ff444322c233@suse.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
 <00c2a9d45e39fb294f4995b07a9b7547206c3085.1543374820.git.gustavo@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <00c2a9d45e39fb294f4995b07a9b7547206c3085.1543374820.git.gustavo@embeddedor.com>
Content-Language: de-DE
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Stefano Stabellini <sstabellini@kernel.org>, xen-devel@lists.xenproject.org
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 28/11/2018 05:34, Gustavo A. R. Silva wrote:
> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
> where we are expecting to fall through.
> 
> Notice that, in this particular case, I replaced
> "Missed the backend's Closing state -- fallthrough" with
> "fall through - Missed the backend's Closing state", which
> contains the "fall through" annotation at the beginnig of
> the code comment, which is what GCC is expecting to find.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Reviewed-by: Juergen Gross <jgross@suse.com>


Juergen
