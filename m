From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] megaraid_sas: add an i/o barrier
Date: Wed, 10 Feb 2016 12:25:09 -0500
Message-ID: <yq1oaboa362.fsf@sermon.lab.mkp.net>
References: <56AF67B4.2010702@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <56AF67B4.2010702@redhat.com> (Tomas Henzl's message of "Mon, 1
	Feb 2016 15:12:04 +0100")
Sender: stable-owner@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "Sumit.Saxena@avagotech.com" <Sumit.Saxena@avagotech.com>, "Desai, Kashyap" <Kashyap.Desai@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Tomas" == Tomas Henzl <thenzl@redhat.com> writes:

Tomas> A barrier should be added to ensure proper ordering of memory
Tomas> mapped writes.

Tomas> V2: - added the barrier also to megasas_fire_cmd_skinny, as
Tomas> suggested by Kashyap Desai

Sumit, Kashyap: Please review this patch.

-- 
Martin K. Petersen	Oracle Linux Engineering
