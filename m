Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=183.62.165.209
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793878435;
	b=RYYGkn8J9Loh7iuMZmQ49DA8UaZ8x0l+8tnR4imyqCQ1YGOEpTBinIljcqAG7xw2goR9
	 Un903xeey22EsgeAR9R4Cm8MKHug647QOAOuILx+f+/TlqJTzOv7C6qnCsWGAXDEFLChw
	 HlqA9pl2atByWJFPqUqv3If6aStRZoCOD/7SmLxQbmNQe6Ns7YFSbByuA6fHxIN1YJ8T4
	 aIRqVjDibgof3Bis5Zi1pwIX5q+E0qIl8IEmgrEE/cFlDvHa4U3xChFvsgsyXLSQ/vEji
	 1SLFYzpaAFkM9qKsCGhNwzG0PZ8CQ+Dea4EcQu2f1eAkSrDeCG2QXYT5kQJXec4uneQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793878435;
	h=DMARC-Filter:Received:Received:Received:X-Zmail-TransId:X-Mailer:
	 Message-ID:Date:Mime-Version:From:To:Cc:Subject:Content-Type:X-MAIL:
	 X-TLS:X-ENVELOPE-SENDER:X-SOURCE-IP:X-CLEAN:
	 X-Fangmail-Anti-Spam-Filtered:X-Fangmail-MID-QID;
	bh=9tkZ8OPzjjaxlWvc6Mc9inpVkFjM5yQ2KZkyJS+/6hs=;
	b=EJRl9FrA2EyMCI5s9YIM1TEhMyq63HupONKD162nqDEaoL9QPOUdBrF6oEoBVBI9Ph12
	 JDB0jzDaYxVplRoLgdz+sC7+VX9Hq1RlsfCblKaZLnZh4wv1OxW0Kee7mb7+gfoCuZ3Kx
	 KQncTqW+ALJbG+GHhCVmVGhmDFhawh5tu3VxKitu/D9OBgM6PTT08goYaJ0l0fwYPfk0g
	 Cj8y3VQqOkGxNdWPyxEitnvMINe6fnu1aoZ+ymNH976ItCp0vTwwDcFz0/i8z2HQ5ETFV
	 rIfZht5soXEn+VXfTCXOJKTfbt8lXoX3JvrI/hOnW5ec6piMmC45Vv5GHMXLLKtwi2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	arc=none smtp.remote-ip=183.62.165.209
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24793606A326;
	Thu,  5 Nov 2026 11:33:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 24793606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4jL0Z215Vgz5B13X;
	Thu, 05 Nov 2026 19:33:46 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl2.zte.com.cn with SMTP id 6A5BXhhW068218;
	Thu, 5 Nov 2026 19:33:43 +0800 (+08)
	(envelope-from shao.mingyin@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Thu, 5 Nov 2026 19:33:46 +0800 (CST)
X-Zmail-TransId: 2afb6aec699af84-15795
X-Mailer: Zmail v1.0
Message-ID: <20261105193346452uAUQ3LtGtsQ_d_O9gjAw5@zte.com.cn>
Date: Thu, 5 Nov 2026 19:33:46 +0800 (CST)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
From: <shao.mingyin@zte.com.cn>
To: <mkp@kernel.org>, <linux-scsi@vger.kernel.org>,
        <target-devel@vger.kernel.org>
Cc: <James.Bottomley@HansenPartnership.com>, <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIIDAvMl0gdGFyZ2V0OiByZW1vdmUgZGVhZCBrbWFwIGNoZWNrcw==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 6A5BXhhW068218
X-TLS: YES
X-ENVELOPE-SENDER: shao.mingyin@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Thu, 05 Nov 2026 19:33:46 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AEC699A.000/4jL0Z215Vgz5B13X

kmap() and kmap_local_page() never return NULL, so the checks after them are
dead code.  Remove them.

No functional change intended; both patches are independent and can be
applied on their own or as a subset.

Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
---
base-commit: 7649ba73f9e7e1e04d0b46213e39c79ae09dd55c
