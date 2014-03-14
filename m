From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 08/11][SCSI]mpt2sas: Added Reply Descriptor Post Queue (RDPQ) Array support
Date: Fri, 14 Mar 2014 16:41:00 -0400
Message-ID: <yq1mwgswm1v.fsf@sermon.lab.mkp.net>
References: <20140314154256.GA8041@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140314154256.GA8041@lsi.com> (Sreekanth Reddy's message of
	"Fri, 14 Mar 2014 21:12:56 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>
Cc: jejb@kernel.org, JBottomley@Parallels.com, linux-scsi@vger.kernel.org, Sathya.Prakash@lsi.com, Nagalakshmi.Nandigama@lsi.com, linux-kernel@vger.kernel.org, sreekanthreddy0547@gmail.com
List-Id: linux-scsi@vger.kernel.org

>>>>> "Sreekanth" == Reddy, Sreekanth <Sreekanth.Reddy@lsi.com> writes:

Sreekanth,

Sreekanth> The size of this contiguous block of memory pool is directly
Sreekanth> proportional to number of MSI-X vectors and the HBA queue
Sreekanth> depth. For example higher MSIX vectors requires larger
Sreekanth> contiguous block of memory pool.

Please also consider these patches that fix MSI-X issues on large
systems:

  http://marc.info/?l=linux-scsi&m=138879464506586

  http://marc.info/?l=linux-scsi&m=138879465206588

-- 
Martin K. Petersen	Oracle Linux Engineering
