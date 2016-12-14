From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 03/22] qla2xxx: Set tcm_qla2xxx version to automatically
 track qla2xxx version.
Date: Wed, 14 Dec 2016 13:12:29 -0800
Message-ID: <20161214211229.GA14133@infradead.org>
References: <1481056251-2310-1-git-send-email-himanshu.madhani@cavium.com>
 <1481056251-2310-4-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1481056251-2310-4-git-send-email-himanshu.madhani@cavium.com>
Sender: target-devel-owner@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: target-devel@vger.kernel.org, nab@linux-iscsi.org, giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Please just remove TCM_QLA2XXX_VERSION entirely and use QLA2XXX_VERSION
directly instead.
