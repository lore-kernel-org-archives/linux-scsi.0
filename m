From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] target: Pass through I/O topology for block backstores
Date: Mon, 11 Nov 2013 20:48:10 -0500
Message-ID: <yq1siv21jc5.fsf@sermon.lab.mkp.net>
References: <1384189158-19913-1-git-send-email-agrover@redhat.com>
	<1384189158-19913-2-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1384189158-19913-2-git-send-email-agrover@redhat.com> (Andy
	Grover's message of "Mon, 11 Nov 2013 08:59:17 -0800")
Sender: target-devel-owner@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Andy" == Andy Grover <agrover@redhat.com> writes:

Andy> In addition to block size (already implemented), passing through
Andy> alignment offset, logical-to-phys block exponent, I/O granularity
Andy> and optimal I/O length will allow initiators to properly handle
Andy> layout on LUNs with 4K block sizes.

Looks good to me, Andy.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
