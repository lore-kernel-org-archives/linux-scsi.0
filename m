From: christophe.varoqui@free.fr
Subject: storageworks
Date: Mon, 14 Apr 2003 11:58:57 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1050314337.3e9a86619a829@imp.free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from postfix4-1.free.fr ([213.228.0.62]:46976 "EHLO
	postfix4-1.free.fr") by vger.kernel.org with ESMTP id S262932AbTDNJrK (for <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Apr 2003 05:47:10 -0400
List-Id: linux-scsi@vger.kernel.org
To: ravi.anand@qlogic.com
Cc: linux-scsi@vger.kernel.org

Hello,

As a qlogic and storageworks user-client, I would like to know if you plan on
supporting transparent failover with HSG and HSG controlers.

My tests so far resulted in an IO error (and apps segfault) when the active path
goes down (portdisable or active controler restart). Strangely, if I run a dd
during the failover, it blocks "normaly" until the failover is done (as shown in
/var/log/messages), then IO start as expected.

Let me also suggest that you introduce a simpler way the inhibit the failback
behaviour, which is needed with HSG controlers. An auto-detection would be be ideal.

respects,
cvaroqui
