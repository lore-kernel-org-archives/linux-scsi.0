From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] Remove an extra out label in _fcoe_create function
Date: Fri, 02 Jun 2017 17:32:21 -0400
Message-ID: <yq1y3tahy8q.fsf@oracle.com>
References: <0d0539e8-ec2e-eac3-a91b-bfda55e83eca@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <0d0539e8-ec2e-eac3-a91b-bfda55e83eca@redhat.com> (Milan
        P. Gandhi's message of "Thu, 1 Jun 2017 17:38:55 +0530")
Sender: kernel-janitors-owner@vger.kernel.org
To: "Milan P. Gandhi" <mgandhi@redhat.com>
Cc: linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, Laurence Oberman <loberman@redhat.com>, Johannes Thumshirn <jth@kernel.org>
List-Id: linux-scsi@vger.kernel.org


Milan,

> This patch removes an extra out label in _fcoe_create function
> where we return if creation of FCOE interface is failed.

Applied to 4.13/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
