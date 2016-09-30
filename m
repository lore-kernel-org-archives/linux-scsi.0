From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 0/3] g_NCR5380: Modernization
Date: Thu, 29 Sep 2016 21:53:37 -0400
Message-ID: <yq1vaxeup9a.fsf@sermon.lab.mkp.net>
References: <1475002825-18132-1-git-send-email-linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1475002825-18132-1-git-send-email-linux@rainbow-software.org>
        (Ondrej Zary's message of "Tue, 27 Sep 2016 21:00:22 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Christoph Hellwig <hch@infradead.org>, Finn Thain <fthain@telegraphics.com.au>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Ondrej" == Ondrej Zary <linux@rainbow-software.org> writes:

Ondrej> This small patch series removes deprecated code from g_NCR5380
Ondrej> driver and converts it from scsi_module.c to scsi_add_host().

Applied to 4.9/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
