From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 01/41] scsi: BusLogic: mark expected switch fall-through
Date: Fri, 07 Dec 2018 21:35:46 -0500
Message-ID: <yq1y390n3st.fsf@oracle.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
        <de0c68b4f655080a7336d1ad256d77a83ab0b7d6.1543374820.git.gustavo@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <de0c68b4f655080a7336d1ad256d77a83ab0b7d6.1543374820.git.gustavo@embeddedor.com>
        (Gustavo A. R. Silva's message of "Tue, 27 Nov 2018 22:21:23 -0600")
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Khalid Aziz <khalid@gonehiking.org>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Gustavo A.,

> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
> where we are expecting to fall through.

Applied to 4.21/scsi-queue, thanks.

-- 
Martin K. Petersen	Oracle Linux Engineering
