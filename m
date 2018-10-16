From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/2] target: Fix target_wait_for_sess_cmds breakage with active signals
Date: Tue, 16 Oct 2018 00:13:38 -0400
Message-ID: <yq1lg6yv899.fsf@oracle.com>
References: <1539141790-13557-1-git-send-email-nab@linux-iscsi.org>
        <1539141790-13557-3-git-send-email-nab@linux-iscsi.org>
        <5BBE2FBF.7080804@redhat.com>
        <1539237365.6150.32.camel@haakon3.daterainc.com>
        <F43269BA-4D7B-486C-87C6-0FB48FF890EA@catalogicsoftware.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <F43269BA-4D7B-486C-87C6-0FB48FF890EA@catalogicsoftware.com>
        (Bryant Ly's message of "Thu, 11 Oct 2018 13:05:59 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: "Ly, Bryant" <bly@catalogicsoftware.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Mike Christie <mchristi@redhat.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Bart Van Assche <bvanassche@acm.org>
List-Id: linux-scsi@vger.kernel.org


Bryant,

> VMs do not remove the I_T nexus while the VM is active, so we can remove
> the target_wait_for_sess_cmd() call. 

Patch forthcoming?

-- 
Martin K. Petersen	Oracle Linux Engineering
