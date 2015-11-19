From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 RESEND_2] scsi: report 'INQUIRY result too short' once per host
Date: Thu, 19 Nov 2015 08:44:47 -0500
Message-ID: <yq1wptenlww.fsf@sermon.lab.mkp.net>
References: <1447939026-25306-1-git-send-email-vkuznets@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447939026-25306-1-git-send-email-vkuznets@redhat.com> (Vitaly
	Kuznetsov's message of "Thu, 19 Nov 2015 14:17:06 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "K. Y. Srinivasan" <kys@microsoft.com>, Hannes Reinecke <hare@suse.de>, Long Li <longli@microsoft.com>, Dexuan Cui <decui@microsoft.com>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Vitaly" == Vitaly Kuznetsov <vkuznets@redhat.com> writes:

Vitaly> Some host adapters (e.g. Hyper-V storvsc) are known for not
Vitaly> respecting the SPC-2/3/4 requirement for 'INQUIRY data (see
Vitaly> table ...) shall contain at least 36 bytes'. As a result we get
Vitaly> tons on 'scsi 0:7:1:1: scsi scan: INQUIRY result too short (5),
Vitaly> using 36' messages on console. This can be problematic for slow
Vitaly> consoles. Introduce short_inquiry flag in struct Scsi_Host to
Vitaly> print the message once per host.

Applied to the 4.4 queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
