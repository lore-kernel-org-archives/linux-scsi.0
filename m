From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v1 0/3] Ibmvscsis fixes and code cleanup
Date: Fri, 02 Sep 2016 06:53:51 -0400
Message-ID: <yq1h99ytvwg.fsf@sermon.lab.mkp.net>
References: <1472660941-23856-1-git-send-email-bryantly@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1472660941-23856-1-git-send-email-bryantly@linux.vnet.ibm.com>
        (Bryant G. Ly's message of "Wed, 31 Aug 2016 11:28:58 -0500")
Sender: target-devel-owner@vger.kernel.org
To: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Cc: nab@linux-iscsi.org, dan.carpenter@oracle.com, mikecyr@linux.vnet.ibm.com, James.Bottomley@HansenPartnership.com, tyreld@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, martin.petersen@oracle.com
List-Id: linux-scsi@vger.kernel.org

>>>>> "Bryant" == Bryant G Ly <bryantly@linux.vnet.ibm.com> writes:

Bryant,

Bryant> Here are some small fixes and cleanups for Ibmvscsis Target
Bryant> Driver.  The only one of significance is the first one where
Bryant> there is a possibility of a kernel crash due to inproper
Bryant> deregister of target session since we didn't sync up work and
Bryant> didn't deregister_configfs.

Applied to 4.9/scsi-queue.

I did patch 2 by hand. It didn't apply to neither my tree, nor Nic's.

-- 
Martin K. Petersen	Oracle Linux Engineering
