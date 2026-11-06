Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=183.62.165.209
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793950983;
	b=N0r9Dz6thhDYxccMfDI3hv2WXeNbGVWuKVZSKMuamPc+toovaiTfGG+KTYloe2IZH4ZY
	 vzhphYud8Bgy7lql3pGYqqyWIaGfa0sB9UyPBzh0lrANmqyuYAbhoF/aFCyHuRZJh58On
	 Uwy+YomQQTJf9Mfrtp+UKz2LmqcFMZ9yN83D6oVn7VPdN6XI1NTzdT/cfwgfRiHFnvXfB
	 3379fEc5fAWpKA0LedGD77o/NaVROnCX6k4iHBvuLyV1In9sZskqD6YqQTApWGl850udG
	 GVu7GyXHF8+5w80o9KOFodA7zddKYG+D8K6p0QfOXTDdwkFMzN5yapApbfrPJuahdTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793950983;
	h=DMARC-Filter:Received:Received:Received:X-Zmail-TransId:X-Mailer:
	 Message-ID:In-Reply-To:References:Date:Mime-Version:From:To:Cc:
	 Subject:Content-Type:X-MAIL:X-TLS:X-ENVELOPE-SENDER:X-SOURCE-IP:
	 X-CLEAN:X-Fangmail-Anti-Spam-Filtered:X-Fangmail-MID-QID;
	bh=3zEnSlKjgEmqBBqN8oJGF/sbHnF5CMLVebebB7TUtv0=;
	b=mGhM4rLMOsYhlEdIW0Q8Lh7JGICOLWbA0Pe49NEBJJYd97PLP+l55Y3J4DMQeUMrm/P8
	 ueIbPX5zoW2w5SB/LjMhzkvVUqK6fjjrgLMDvysY9fK0SgKQTC/GuzZtKqnApQ7djNX2+
	 VpvPb8IKjyA+GaeFESpFMlKXr7lX353SgHA2YPae3ACu781RIufqfyfl7iDYt8tQhI9yR
	 QZ9SAZla07hyf86EyguO0f8gAcHKQaskh7Rn13aT/BjsDRJA5buWqgHwK0rMfPvFboZBr
	 8EF7yCkKF/rbYEj180YnQOfG6hE7cDt84RaWrBAHJnqwclSUIuaBTmQA388HOzaEHIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	arc=none smtp.remote-ip=183.62.165.209
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C56606A32C;
	Fri,  6 Nov 2026 07:43:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D3C56606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4jLWP63r7wz4x69j;
	Fri, 06 Nov 2026 15:42:50 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl1.zte.com.cn with SMTP id 6A67glxv020847;
	Fri, 6 Nov 2026 15:42:47 +0800 (+08)
	(envelope-from shao.mingyin@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Fri, 6 Nov 2026 15:42:49 +0800 (CST)
X-Zmail-TransId: 2afc6aed84f9706-0b926
X-Mailer: Zmail v1.0
Message-ID: <20261106154249856uVdt_3q0fOVK2PnP_8p9T@zte.com.cn>
In-Reply-To: <b2614f98-e21c-459b-8dfb-f2a1cea93214@acm.org>
References: 20261105193328462jmyNd656AIL6fPlbEJ1Ki@zte.com.cn,b2614f98-e21c-459b-8dfb-f2a1cea93214@acm.org
Date: Fri, 6 Nov 2026 15:42:49 +0800 (CST)
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
To: <bvanassche@acm.org>, <mkp@kernel.org>, <linux-scsi@vger.kernel.org>
Cc: <James.Bottomley@HansenPartnership.com>, <alim.akhtar@samsung.com>,
        <beanhuo@micron.com>, <stanleyjhu@google.com>, <loberman@redhat.com>,
        <jmeneghi@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCAwLzVdIHNjc2k6IHJlbW92ZSBkZWFkIGNvZGUgYW5kIHJlZHVuZGFudCBjaGVja3M=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 6A67glxv020847
X-TLS: YES
X-ENVELOPE-SENDER: shao.mingyin@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Fri, 06 Nov 2026 15:42:50 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AED84FA.000/4jLWP63r7wz4x69j

On 11/5/26 09:54, Bart Van Assche wrote:
> A cover letter doesn't need a Signed-off-by.

Right, I will drop it from the v2 cover; the per-patch Signed-off-by lines
stay.  I will resend the whole series as v2 with the changes requested for
patches 4 and 5.

Thanks,
Shao
