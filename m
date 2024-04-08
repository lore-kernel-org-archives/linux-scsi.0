Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B851852
	for <linux-scsi@vger.kernel.org>; Mon,  8 Apr 2024 02:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712544872; cv=none; b=t8En7raADpAUBIL06gTMlgJhRIzUnCemgq8QZQi+lw70EH2duQQHPne6yqL6D3C0qC2manktjLsSuvgdSmokwdWYKmYbqKB/xM0tmaC1pP5YI6Z5uqF4AtaeaDqwcKmXYqtg3pUJp9kvDWiwFHpAAphjHHExJ8Ed0eFef4Bzb5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712544872; c=relaxed/simple;
	bh=cOMF66qtRKrf57DQRiV6olcX9uzVeCSkqZoNpTNq/cs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LFU8gXPkWgMfHWBOeJwNfN1l7G+diHQ+tPGfhu5VxernrBLQzlrFXA6rsVCQ+jmCVw+XkuFiVWEj4xnZ3bC65OwFVmFL3bq6iJGiS5K3+AzlsI5mbF7l7wyAyXTzIYIdKWtACssy2mrQ2DvaW8jIqp8fxkn8Z5WP3/dCNNcEOQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YWR9OYnZ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YWR9OYnZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=qPP2o8ZO1A5+FEv1JPt3M6daAduWEaNfV+ef7kfphK8=; b=YWR9OYnZ3lvjmEqaL56eb1mD7S
	rBogRrUDcAhHk4DQ5w7H7dKpmSnaXPnBkVybrexUTGKy4amiRNa1+cZUA6ssGSBGjpyrVXU+LbvSB
	DB0GiYPz3nYNMJjToZlciXstxiJvCVQIJhoIWTkdno9ntk6193C15SxTLbgfQr6HJ2jQ0UgS7c+US
	l45NDmVLWnIvvEQqLEO8LrnTtcO5sqBan5mxJcr9FR+I92unhSaRGOHKY/RrFuEHGfZN4eX7/APrn
	AVoqVnRCRSH9Zz3XnmhJJTFyXiB82IGuTUjR11jL+il8etNyY8wLUcWNkYpWsxc0GVGG1V/lsra0m
	8FyF1xHQ==;
Received: from [50.53.2.121] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rtf9S-0000000E7aj-3tsA;
	Mon, 08 Apr 2024 02:54:31 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-scsi@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 7/8] scsi: scsi_transport_fc: add kernel-doc for function return
Date: Sun,  7 Apr 2024 19:54:24 -0700
Message-ID: <20240408025425.18778-8-rdunlap@infradead.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408025425.18778-1-rdunlap@infradead.org>
References: <20240408025425.18778-1-rdunlap@infradead.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add function return value to prevent a kernel-doc warning:

scsi_transport_fc.h:780: warning: No description found for return value of 'fc_remote_port_chkready'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

 include/scsi/scsi_transport_fc.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -- a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -770,10 +770,9 @@ struct fc_function_template {
 /**
  * fc_remote_port_chkready - called to validate the remote port state
  *   prior to initiating io to the port.
- *
- * Returns a scsi result code that can be returned by the LLDD.
- *
  * @rport:	remote port to be checked
+ *
+ * Returns: a scsi result code that can be returned by the LLDD.
  **/
 static inline int
 fc_remote_port_chkready(struct fc_rport *rport)
