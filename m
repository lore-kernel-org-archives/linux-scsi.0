From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 41/41] scsi: xen-scsifront: mark expected switch fall-through
Date: Wed, 28 Nov 2018 21:52:38 -0500
Message-ID: <yq1tvk0y4qx.fsf@oracle.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
        <00c2a9d45e39fb294f4995b07a9b7547206c3085.1543374820.git.gustavo@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <00c2a9d45e39fb294f4995b07a9b7547206c3085.1543374820.git.gustavo@embeddedor.com>
        (Gustavo A. R. Silva's message of "Tue, 27 Nov 2018 22:34:35 -0600")
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Stefano Stabellini <sstabellini@kernel.org>, xen-devel@lists.xenproject.org, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Gustavo A.,

> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
> where we are expecting to fall through.
>
> Notice that, in this particular case, I replaced
> "Missed the backend's Closing state -- fallthrough" with
> "fall through - Missed the backend's Closing state", which
> contains the "fall through" annotation at the beginnig of
> the code comment, which is what GCC is expecting to find.

Applied to 4.21/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
