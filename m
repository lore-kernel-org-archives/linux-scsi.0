From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: advansys: Remove unnecessary parentheses
Date: Tue, 25 Sep 2018 20:48:50 -0400
Message-ID: <yq1y3bpgk25.fsf@oracle.com>
References: <20180920205858.6035-1-natechancellor@gmail.com>
        <9432dde7-c63f-9c0c-fc9b-8728a0715ff3@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <9432dde7-c63f-9c0c-fc9b-8728a0715ff3@suse.com> (Hannes
        Reinecke's message of "Fri, 21 Sep 2018 07:57:31 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.com>
Cc: Nathan Chancellor <natechancellor@gmail.com>, Matthew Wilcox <matthew@wil.cx>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Hannes,

> On 9/20/18 10:58 PM, Nathan Chancellor wrote:
>> Clang warns when multiple pairs of parentheses are used for a single
>> conditional statement.

Applied to 4.20/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
