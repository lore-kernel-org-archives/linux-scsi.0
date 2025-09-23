Received: from sender4-g3-154.zohomail360.com (sender4-g3-154.zohomail360.com [136.143.188.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CD6B1B6D06
	for <linux-scsi@vger.kernel.org>; Wed, 24 Sep 2025 00:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.154
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758674645; cv=pass; b=krUeRMS9XpRw61Hhpmd/WOev12dfuIzNYXJVrwVU1nZrVSdhsqy2FagivbAPKTJduBI8wA75cF8JnCXh6nXl+oHevtO9NHIwpPzwAsYf339Ui+CMD9BBy1xWoqfCw+SomVLnKm2SG2Ulp7fw5xbLCNVDmLu3bkkUgbf9pLeZH5M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758674645; c=relaxed/simple;
	bh=lDyEitQV9bDZhJu0i2I5qfrBKEYYJs7SwHJwp+ziUHo=;
	h=Date:From:To:Message-ID:Subject:MIME-Version:Content-Type; b=KDYC2D9cSdBQss/x9gDFQ0fGo5FkPSl5OJIK0RNwC43fmJTusqbYTrlbKjTV0LXNc5UbqozS4JRe2N/gidKKhuT9IdKfNnTHyW3yM/iUKSq8OTDJZKEDhPIorMpxzy1+oNin5z0TzO+ZodpdVE43hew9GudclUZjJ6+w9Ue+QqE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=maguitec.com.mx; spf=pass smtp.mailfrom=bounce-zem.maguitec.com.mx; dkim=pass (1024-bit key) header.d=maguitec.com.mx header.i=@maguitec.com.mx header.b=c5e6TRla; arc=pass smtp.client-ip=136.143.188.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=maguitec.com.mx
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bounce-zem.maguitec.com.mx
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=maguitec.com.mx header.i=@maguitec.com.mx header.b="c5e6TRla"
ARC-Seal: i=1; a=rsa-sha256; t=1758674643; cv=none; 
	d=us.zohomail360.com; s=zohoarc; 
	b=M0YLIfd7tBDqqfvKxhvTHFXqbHIfv083vQLeVTDN/vod7B9GMfUOHfng6U04AgQlU0pvimkWU69WKh9Ki2oUWhXVKNBFg1cNhtKq/EMiFUdLlNe+AnxZpA/wg1LH/bNRoEQxTtqf1fJwtAkAfyBNgDmNSP6MEk/2PxVKvC12C4I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=us.zohomail360.com; s=zohoarc; 
	t=1758674643; h=Content-Type:Content-Transfer-Encoding:Date:Date:From:From:MIME-Version:Message-ID:Reply-To:Reply-To:Subject:Subject:To:To:Message-Id:Cc; 
	bh=lDyEitQV9bDZhJu0i2I5qfrBKEYYJs7SwHJwp+ziUHo=; 
	b=P234gn5YShS9JrQ8RpEhrGq4s75js+6cVX4xFANZXWKNG9jMe5/lmXW2ndLAY4fmB5dEUbwQqRqd/uEdHLnhaCeG21g30asN9AoA8GMcKKx/in9omprYGH04pNhevDEovlLP1yb51NU66ojA7Jbf4wMlFZxlIj+bjSOIaJ8s5+s=
ARC-Authentication-Results: i=1; mx.us.zohomail360.com;
	dkim=pass  header.i=maguitec.com.mx;
	spf=pass  smtp.mailfrom=investorrelations+9ab53490-98d8-11f0-ace3-525400721611_vt1@bounce-zem.maguitec.com.mx;
	dmarc=pass header.from=<investorrelations@maguitec.com.mx>
Received: by mx.zohomail.com with SMTPS id 175867165324018.224299141755637;
	Tue, 23 Sep 2025 16:54:13 -0700 (PDT)
DKIM-Signature: a=rsa-sha256; b=c5e6TRlaMkGfsLMs2JIq58ggu19VKvsVk2F/0gYkG8YmqlXchjc5+9fmD4MLsmd66V1vTk2NR5bOQJMEw8bW/RQa3zyMVHqOGsB+VUj7Jz3URE76c39wNntrkdgw+4/0QH9YFzW2jOsjKNwh8O/XU/6zA2lAusnL0+6B6yQHdVA=; c=relaxed/relaxed; s=15205840; d=maguitec.com.mx; v=1; bh=lDyEitQV9bDZhJu0i2I5qfrBKEYYJs7SwHJwp+ziUHo=; h=date:from:reply-to:to:message-id:subject:mime-version:content-type:content-transfer-encoding:date:from:reply-to:to:message-id:subject;
Date: Tue, 23 Sep 2025 16:54:13 -0700 (PDT)
From: Al Sayyid Sultan <investorrelations@maguitec.com.mx>
Reply-To: investorrelations@alhaitham-investment.ae
To: linux-scsi@vger.kernel.org
Message-ID: <2d6f.1aedd99b146bc1ac.m1.9ab53490-98d8-11f0-ace3-525400721611.19978ffc659@bounce-zem.maguitec.com.mx>
Subject: Thematic Funds Letter Of Intent
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: quoted-printable
content-transfer-encoding-Orig: quoted-printable
content-type-Orig: text/plain;\r\n\tcharset="utf-8"
Original-Envelope-Id: 2d6f.1aedd99b146bc1ac.m1.9ab53490-98d8-11f0-ace3-525400721611.19978ffc659
X-JID: 2d6f.1aedd99b146bc1ac.s1.9ab53490-98d8-11f0-ace3-525400721611.19978ffc659
TM-MAIL-JID: 2d6f.1aedd99b146bc1ac.m1.9ab53490-98d8-11f0-ace3-525400721611.19978ffc659
X-App-Message-ID: 2d6f.1aedd99b146bc1ac.m1.9ab53490-98d8-11f0-ace3-525400721611.19978ffc659
X-Report-Abuse: <abuse+2d6f.1aedd99b146bc1ac.m1.9ab53490-98d8-11f0-ace3-525400721611.19978ffc659@zeptomail.com>
X-ZohoMailClient: External

To: linux-scsi@vger.kernel.org
Date: 24-09-2025
Thematic Funds Letter Of Intent

It's a pleasure to connect with you

Having been referred to your investment by my team, we would be=20
honored to review your available investment projects for onward=20
referral to my principal investors who can allocate capital for=20
the financing of it.

kindly advise at your convenience

Best Regards,

Respectfully,
Al Sayyid Sultan Yarub Al Busaidi
Director
