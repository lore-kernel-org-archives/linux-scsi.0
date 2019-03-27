From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] scsi: sd: Quiesce warning if device does not report
 optimal I/O size
Date: Wed, 27 Mar 2019 09:46:13 -0700
Message-ID: <1553705173.118779.98.camel@acm.org>
References: <25d0ddcb-b603-6e0d-d512-b188813837bf@infradead.org>
         <20190327161152.23401-1-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-7"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190327161152.23401-1-martin.petersen@oracle.com>
Sender: stable-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: Hussam Al-Tayeb <ht990332@gmx.com>, Randy Dunlap <rdunlap@infradead.org>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2019-03-27 at 12:11 -0400, Martin K. Petersen wrote:
+AD4 Commit a83da8a4509d (+ACI-scsi: sd: Optimal I/O size should be a multiple
+AD4 of physical block size+ACI) split one conditional into several separate
+AD4 statements in an effort to provide more accurate warning messages when
+AD4 a device reports a nonsensical value. However, this reorganization
+AD4 accidentally dropped the precondition of the reported value being
+AD4 larger than zero. This lead to a warning getting emitted on devices
+AD4 that do not report an optimal I/O size at all.
+AD4 
+AD4 Remain silent if a device does not report an optimal I/O size.
+AD4 
+AD4 Fixes: a83da8a4509d (+ACI-scsi: sd: Optimal I/O size should be a multiple of physical block size+ACI)
+AD4 Reported-by: Hussam Al-Tayeb +ADw-ht990332+AEA-gmx.com+AD4
+AD4 Cc: Randy Dunlap +ADw-rdunlap+AEA-infradead.org+AD4
+AD4 Cc: +ADw-stable+AEA-vger.kernel.org+AD4
+AD4 Signed-off-by: Martin K. Petersen +ADw-martin.petersen+AEA-oracle.com+AD4

Reviewed-by: Bart Van Assche +ADw-bvanassche+AEA-acm.org+AD4
