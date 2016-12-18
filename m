From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 8/9] qla2xxx: Add T10-DIF opcode/type in qla_tgt_cmd
Date: Sun, 18 Dec 2016 01:52:15 -0800
Message-ID: <20161218095215.GF23338@infradead.org>
References: <1482051769-22941-1-git-send-email-himanshu.madhani@cavium.com>
 <1482051769-22941-9-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1482051769-22941-9-git-send-email-himanshu.madhani@cavium.com>
Sender: target-devel-owner@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: target-devel@vger.kernel.org, bart.vanassche@gmail.com, hch@infradead.org, nab@linux-iscsi.org, giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

NAK again, duplicating fields in a common structure in a
driver-specific one is an absolute anti-pattern.
