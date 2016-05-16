From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/2] target: fix max discard sectors calculation
Date: Mon, 16 May 2016 15:02:22 -0400
Message-ID: <yq1y479hlmp.fsf@sermon.lab.mkp.net>
References: <1463424410-17196-1-git-send-email-mchristi@redhat.com>
	<1463424410-17196-3-git-send-email-mchristi@redhat.com>
	<573A1826.3050007@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <573A1826.3050007@sandisk.com> (Bart Van Assche's message of
	"Mon, 16 May 2016 11:57:42 -0700")
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: mchristi@redhat.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, socketpair@gmail.com, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Bart" == Bart Van Assche <bart.vanassche@sandisk.com> writes:

Bart> That's a good catch. But seeing this patch makes me wonder whether
Bart> this patch introduces a 64-bit division? If so, I'm afraid this
Bart> patch will make 32-bit users unhappy. Have you considered to use
Bart> do_div() or >> (ilog2(block_size) - 9) instead? For the latter
Bart> alternative no 64-bit cast is needed.

Please use logical_to_sectors().

-- 
Martin K. Petersen	Oracle Linux Engineering
