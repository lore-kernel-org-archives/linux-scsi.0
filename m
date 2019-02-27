From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: aacraid: Fix missing break in switch statement
Date: Wed, 27 Feb 2019 09:33:47 -0500
Message-ID: <yq1pnrd9u7o.fsf@oracle.com>
References: <20190215214242.GA8393@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190215214242.GA8393@embeddedor> (Gustavo A. R. Silva's message
        of "Fri, 15 Feb 2019 15:42:42 -0600")
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
List-Id: linux-scsi@vger.kernel.org


Gustavo,

> Add missing break statement and fix identation issue.

So much bad indentation in this driver. Tried various tab widths and it
is still all over the place.

Anyway. After staring at the firmware header I have convinced myself
that your fix is correct. Applied to 5.1/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
