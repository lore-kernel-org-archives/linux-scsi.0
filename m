From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] drivers, scsi: convert fc_fcp_pkt.ref_cnt from atomic_t to refcount_t
Date: Wed, 15 Mar 2017 19:07:51 -0400
Message-ID: <yq18to6gmuw.fsf@oracle.com>
References: <1489045442-18738-1-git-send-email-elena.reshetova@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1489045442-18738-1-git-send-email-elena.reshetova@intel.com>
        (Elena Reshetova's message of "Thu, 9 Mar 2017 09:44:02 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: jth@kernel.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, fcoe-devel@open-fcoe.org, linux-kernel@vger.kernel.org, Hans Liljestrand <ishkamiel@gmail.com>, Kees Cook <keescook@chromium.org>, David Windsor <dwindsor@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Elena Reshetova <elena.reshetova@intel.com> writes:

> refcount_t type and corresponding API should be used instead of
> atomic_t when the variable is used as a reference counter. This allows
> to avoid accidental refcounter overflows that might lead to
> use-after-free situations.

Applied to 4.12/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
