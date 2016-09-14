From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/3] wireless: Use complete() instead complete_all()
Date: Wed, 14 Sep 2016 13:23:46 -0400
Message-ID: <yq17faemm3h.fsf@sermon.lab.mkp.net>
References: <1473757130-14751-1-git-send-email-wagi@monom.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1473757130-14751-1-git-send-email-wagi@monom.org> (Daniel
        Wagner's message of "Tue, 13 Sep 2016 10:58:47 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Wagner <wagi@monom.org>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-kernel@vger.kernel.org, Daniel Wagner <daniel.wagner@bmw-carit.de>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Daniel" == Daniel Wagner <wagi@monom.org> writes:

Daniel> Using complete_all() is not wrong per se but it suggest that
Daniel> there might be more than one waiter. For -rt I am reviewing all
Daniel> complete_all() users and would like to leave only the real ones
Daniel> in the tree. The main problem for -rt about complete_all() is
Daniel> that it can be uses inside IRQ context and that can lead to
Daniel> unbounded amount work inside the interrupt handler. That is a no
Daniel> no for -rt.

Daniel> The patches grouped per subsystem and in small batches to allow
Daniel> reviewing.

Applied to 4.9/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
