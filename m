From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 22/29] qla2xxx: Update LICENSE.qla2xxx.
Date: Thu, 9 Feb 2012 11:15:54 -0800
Message-ID: <1328814961-21866-23-git-send-email-chad.dupuis@qlogic.com>
References: <1328814961-21866-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:41846
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758411Ab2BITcM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2012 14:32:12 -0500
Received: from mail102-ch1 (localhost [127.0.0.1])	by
 mail102-ch1-R.bigfish.com (Postfix) with ESMTP id DE1DC60572	for
 <linux-scsi@vger.kernel.org>; Thu,  9 Feb 2012 19:32:11 +0000 (UTC)
In-Reply-To: <1328814961-21866-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 Documentation/scsi/LICENSE.qla2xxx |   41 +----------------------------------
 1 files changed, 2 insertions(+), 39 deletions(-)

diff --git a/Documentation/scsi/LICENSE.qla2xxx b/Documentation/scsi/LICENSE.qla2xxx
index 19e7cd4..ce0fdf3 100644
--- a/Documentation/scsi/LICENSE.qla2xxx
+++ b/Documentation/scsi/LICENSE.qla2xxx
@@ -1,48 +1,11 @@
 Copyright (c) 2003-2011 QLogic Corporation
-QLogic Linux/ESX Fibre Channel HBA Driver
+QLogic Linux FC-FCoE Driver
 
-This program includes a device driver for Linux 2.6/ESX that may be
-distributed with QLogic hardware specific firmware binary file.
+This program includes a device driver for Linux 3.x.
 You may modify and redistribute the device driver code under the
 GNU General Public License (a copy of which is attached hereto as
 Exhibit A) published by the Free Software Foundation (version 2).
 
-You may redistribute the hardware specific firmware binary file
-under the following terms:
-
-	1. Redistribution of source code (only if applicable),
-	   must retain the above copyright notice, this list of
-	   conditions and the following disclaimer.
-
-	2. Redistribution in binary form must reproduce the above
-	   copyright notice, this list of conditions and the
-	   following disclaimer in the documentation and/or other
-	   materials provided with the distribution.
-
-	3. The name of QLogic Corporation may not be used to
-	   endorse or promote products derived from this software
-	   without specific prior written permission
-
-REGARDLESS OF WHAT LICENSING MECHANISM IS USED OR APPLICABLE,
-THIS PROGRAM IS PROVIDED BY QLOGIC CORPORATION "AS IS'' AND ANY
-EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
-IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
-PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR
-BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
-EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
-TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
-DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
-ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
-OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
-OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
-POSSIBILITY OF SUCH DAMAGE.
-
-USER ACKNOWLEDGES AND AGREES THAT USE OF THIS PROGRAM WILL NOT
-CREATE OR GIVE GROUNDS FOR A LICENSE BY IMPLICATION, ESTOPPEL, OR
-OTHERWISE IN ANY INTELLECTUAL PROPERTY RIGHTS (PATENT, COPYRIGHT,
-TRADE SECRET, MASK WORK, OR OTHER PROPRIETARY RIGHT) EMBODIED IN
-ANY OTHER QLOGIC HARDWARE OR SOFTWARE EITHER SOLELY OR IN
-COMBINATION WITH THIS PROGRAM.
 
 
 EXHIBIT A
-- 
1.6.0.2


