From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/2] scsi: Fix endless loop of ATA hard resets due to VPD reads
Date: Tue, 02 Feb 2016 21:45:48 -0500
Message-ID: <yq1fuxamrz7.fsf@sermon.lab.mkp.net>
References: <20160121063039.3803.66.stgit@localhost.localdomain>
	<20160202101830.GA3786@node.shutemov.name>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160202101830.GA3786@node.shutemov.name> (Kirill A. Shutemov's
	message of "Tue, 2 Feb 2016 12:18:30 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Alexander Duyck <aduyck@mirantis.com>, jbottomley@odin.com, hare@suse.de, linux-scsi@vger.kernel.org, alexander.duyck@gmail.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, shane.seymour@hpe.com, jthumshirn@suse.de
List-Id: linux-scsi@vger.kernel.org

>>>>> "Kirill" == Kirill A Shutemov <kirill@shutemov.name> writes:

Kirill> I have the same problem.

Kirill> Shouldn't we put quirk for that?

I was hoping that Hannes' patch would do the trick so we could avoid
blacklisting:

	https://patchwork.kernel.org/patch/8079011/

-- 
Martin K. Petersen	Oracle Linux Engineering
