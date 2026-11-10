Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.139.74
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794335350;
	b=wKVyjc56ANFV9/DpPI7On6BBezEpdLxve//vQ28GEb4xKRAe8hpbuKXBXuM+PYMkQeMD
	 WV6FNW3vvb7ITCdLHDIyNpwmYYCHYsjTdfcTHjjDghFBbv1iDDE1XoNApw4H5h2REch3W
	 2WhQlJE/uZXPbG7cwAaty6zAet8Bmq14aYM1bJVQKV/KEGjK3HeOXfqguwmy1TMg2kBfK
	 GZ5f2aI4rxjbkTouciE7p91MsJ/p9UUy0E74ctFHRSBQdTF65qrZI4E9HtvmhjSjf9a+G
	 PNYK7eIBWNDvfCVSVNpSMaHaFP43N090401Wzh39edZemT4ctSyAOGmpG8SgYm9DY8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794335350;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:
	 Subject:Date:Message-Id:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=9w1TbN1dvve0swdMnEQBNdtFLKErrDV4D/BBl+8lzPA=;
	b=JdQ6RJNGOZ0o1Y+06SDiFlpb61k9Hbt932M5UbGQQP4JjyQ7H3iGZXbnvSwZvdyBl1J+
	 g1m7oGPnIDZLSoCfB+wK93DO4HAfiHgPRsczPMOyj/kgBL0P3K8K6g829wmHsW3BMAB0h
	 3nFFN4zvsVTENKbKx+BT16NoOIZ6YUgpT3ZE1Q876wG0pwWA2O55w3BN9yBVY7+Htdj11
	 VGuqYFID2nBz0ZeIWao+O0hmHGhYm4abwkzj6b5f6XFTD4ysgQgkM3ULGCZxs/5r99EuP
	 0svy6kuMy5uZFFxAtVkojpjpgIDpMeTU0f5hBZgQZG4arTxRKJGbMdAHMv4PFZ003cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=columbia.edu;
	spf=pass smtp.mailfrom=columbia.edu;
	dkim=pass header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=pW17WZOI;
	dkim=pass header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=z2eizeha;
	arc=none smtp.remote-ip=148.163.139.74
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F418606A332
	for <linux-scsi@vger.kernel.org>; Tue, 10 Nov 2026 18:29:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0F418606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=pW17WZOI;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=z2eizeha
Received: from pps.filterd (m0167076.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AAHZ37t2980473
	for <linux-scsi@vger.kernel.org>; Tue, 10 Nov 2026 13:29:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=9w1TbN1dvve0swdMnEQBNdtFLK
	ErrDV4D/BBl+8lzPA=; b=pW17WZOIAJDOkkRCu349/N41d5Lc822vyMbuu+6fWn
	5ewEeYbVwLKGA8aRWKufjAg8XaeecDUfw3fyTODwHfFxiEn5WJxmXuun07vl3GZM
	F4rTEngoXebZ2IBT8kEZXBDcJ7jbawltSb6zoEoKqgsOWhstcWaLH79gRhFKI1zO
	1le0pyYcSnHJ0TnXe4yGMiMFtsSCqskYMLEiNrT7iWFh6n9Pi2tCseuzaD69a/oM
	aXBwXHI9DITWYhOxAh9MqpITdFRWwQjoeopKh16NfkJV1XRvyQa5YAhGuENHqyQF
	VdxgAS/Af/lEtZ6mWPvpBkqZB/QwoXNZjkuD/OxFeK3Q==
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com [209.85.219.72])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4hv2xebc0w-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 10 Nov 2026 13:29:02 -0500 (EST)
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-91eb16ea5c3so64320476d6.2
        for <linux-scsi@vger.kernel.org>; Tue, 10 Nov 2026 10:29:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794335342; x=1794940142; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=9w1TbN1dvve0swdMnEQBNdtFLKErrDV4D/BBl+8lzPA=;
        b=z2eizehaGSXWA0nKtLIF6vnX2eQun9l7oJnukU7pPO+5NM93HSV2o+QipE78Lb2T7F
         iGmICx2b6aSWGe9ztnDmVqt5jtMETPu7cbIe0buWMUZBhj9ed1ohHBjqyQvbDE+GQ2kL
         9ggTcR6eCrMs+GG+jY/MVEKFNzYeYoL6AjX3W0/zYrfSZW0c5If3KIfP5eSX0MTluoy/
         CfYZCYtY5yZ5WWFsS5q1MU0ZyHWR/oEY4cmnEthdqMqcKszDjLHlrtFbAF+FglscLKrX
         ixrmqm9PYLtMShXqqrViSH9sqFH+0QljJEpVk/5kOA6siX1HyRJlipHUzfsXXMO5GkbC
         67LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794335342; x=1794940142;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=9w1TbN1dvve0swdMnEQBNdtFLKErrDV4D/BBl+8lzPA=;
        b=ydQ3xLFBfEZ/RzHQAEWtq44eQpoCciXwXlx8CGTqj6kgZ5TX40ohmUQNMjiQuIiyv+
         rRWuCgJz2mrSUfQTz0Jsn415XqIkSxfMwVSggzcR5Rxgt8wMg23GlgtrFhCgJ6unkq3t
         zLUTLoEYOFr44c2EhJkveBc38zID2Fbl12upRwYZj9nf7uV1lHSAAUGZOEi5ISQUKN18
         EDVwm5KPp29kL2W9+gIYcx0kNx0Q4z/yKAxkEo2Rs6qMeU5YFJgKWlJuKtL+JJE5dsXa
         DxnUyrPD1bpkp6Onm+zswp84oj/eVI1Q7zc7KKTXYOxEdG9X6DAHWb5n/id0IvqgyBmI
         TFqg==
X-Forwarded-Encrypted: i=1; AL+hErHe4pgNx1hcewZ4Eksz073zsgkph8pukUxlLx679N5PfAR0u6Go2zHy6Dp6FEP0GmOFo9os699FqLmK@vger.kernel.org
X-Gm-Message-State: APuU4Z/xQEWSq8MLYR8iZUfmox4MwVLX+vrFtW/U9ze6M3rXQlIRSkzi
	49mPNxqp50ylm/LHOqrbDDAYsX16RlWcSvz6xj8rRNPbXjSC1PnjRdVpyqpROpV8CYXF6N1/gLi
	ccm2wPA1iplLEY3xEUW/9d69bI5QS8eiP5C1SPCddsHybH7wVGCIOEAvhpEk=
X-Gm-Gg: AYBFou2rKGfNPf/4YvSHs/UqMbdnwlKj2am/YTqEuNWJM99HTJ5jeyztECU4ko/H7Cf
	saVJYC/SMBD+NM5UXeDfz2qwMMLfa2n6gfbqpjj7yK5/Pai1U0wYvnH60vFxluYdCX73gOcLprf
	g8Ol5kA52hdcYQOTIAjYZpFfnklplPc6+7hkjWE11yGdClVDYrb7J0/HDbJYxj3fs2vbYfijdOe
	Y24QoCQrM244Z4SbO6GtLD21mF9vlAZPPI42KrywvAY6diUGY2/9L7EGOJ//a+3v3YLe8UBM5Ee
	DEUjkXXYyU+eEWe03gHdy9oaFet4NcuaF6epnd/Vz71RYXCEheXtRFoS9RaviORFhH18hdFP6I9
	ABO2amnMeIee/FD2EsFLI69yZeBA9aIN/tuUNBYCXUXsMyFXWnkFEs7XdB5CDnQo1il/cp73YhC
	EWTtNPxf2IAsrXy8RNF2X/
X-Received: by 2002:a05:6214:62b:b0:91c:6701:161e with SMTP id 6a1803df08f44-91f04195981mr1970946d6.53.1794335342018;
        Tue, 10 Nov 2026 10:29:02 -0800 (PST)
X-Received: by 2002:a05:6214:62b:b0:91c:6701:161e with SMTP id 6a1803df08f44-91f04195981mr1970486d6.53.1794335341480;
        Tue, 10 Nov 2026 10:29:01 -0800 (PST)
Received: from [127.0.1.1] (nat-128-59-177-200.net.columbia.edu. [128.59.177.200])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ef05493desm26986666d6.45.2026.11.10.10.29.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 10:29:01 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH 0/2] scsi: scsi_debug: fix protection information for
 writes
Date: Tue, 10 Nov 2026 13:28:53 -0500
Message-Id: <20261110-scsi-debug-pi-v1-0-539829902b3a@columbia.edu>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAGZi82oC/yXMTQ5AQAxA4atI15pMJX6vIhZjFLVApohE3N1g+
 S3eu0DZCytU0QWeD1FZ5gCKI3CjnQdG6YIhMUlGZHJUp4Idt/uAq2CfkqHSFWVhDYRm9dzL+f3
 q5rfu7cRueydw3w8/G3uhcQAAAA==
X-Change-ID: 20261107-scsi-debug-pi-f51019c898a0
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <mkp@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        John Garry <john.garry@linux.dev>,
        Luis Chamberlain <mcgrof@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Douglas Gilbert <dgilbert@interlog.com>
Cc: Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794335340; l=1202;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=9b9GbfhcF9wn/lxnEZX2ahoKHWp6i22V5f6J5qILpZY=;
 b=VGKW5qZjJ/w1czSJV7zYJIKlmO9VoB351Y8x4uLA5/s94RM8BRq+lheeXPdXlZikdPeZDXniI
 9iK+Okgw1BsB79HRVj1fW6ltvrTusWYowHYzvoTAjdzGZnceF0/fwYp
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEwMDA3MyBTYWx0ZWRfXzYUtcC+Y+f7Q
 ZHNuAc5UpH1BjbqFN8PkXj/ZWcEKs31F/HXms9mTFTZTnc7m5m4YGPvFFJPfHeYVXlfg0uuKCzM
 MzJc4BUVh0HqrwptK9MmxLeh0vPkagCwe8mwk7GPVCJpXixwhuGLTNCM1ssXgq+aAnPZaIb4tLt
 5sbF0OAurahJvm3yROg1+A9W1erd7KYygJqqOV32AdgaFjdCQKeN0RDOH6r7ehwdDDjm5NViswN
 DymRlO+H0XdD2+E+2d4QWQswnzFMBcnjluLuUqZsHzjl2hliWQy2RQfkNPp2+rB+Lmm69Xux+4q
 DZlwQLLPOPebKBn8Ejdkdclxd1j84fzOpIrr+tSgU7/Z28CUFjQG70lAVhJLhr/xCC4xur7/89/
 aa19RRD2Lk+PVZ0bIiZzN+/LZ6HyebRiO27jfUL79aH2gNDjRpdqXxT+9+fXM1yZz+zVv/xGo8G
 HXW1vL+ZtkqNIRjOpew==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEwMDA3MyBTYWx0ZWRfX8pouhxMjoy8A
 2IpMIGo8lulYqhHMc61VZIF3u+wqAwLKKzVNHhW8nuGHtjrcG2Rw5QPOzUEU4n+yl5w0vJtYnR5
 AUfAzc3fWhWSTYuD2T8P2UM7FhDtJeTygrNd/jJniZ4ZR7YSOHqT
X-Authority-Analysis: v=2.4 cv=cvcOAF4i c=1 sm=1 tr=0 ts=6af3626e cx=c_pps
 a=7E5Bxpl4vBhpaufnMqZlrw==:117 a=OksKZPe/0gFw8ujXGPm25g==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=Qm0qsxP7aFY2tkT6R2MF:22
 a=VwQbUJbxAAAA:8 a=rWoZ2Wt58CihLohAb7IA:9 a=QEXdDO2ut3YA:10
 a=pJ04lnu7RYOZP9TFuWaZ:22
X-Proofpoint-ORIG-GUID: zXzwe6c5sO6oQl4dyGi7h7XJZyJFPhDZ
X-Proofpoint-GUID: zXzwe6c5sO6oQl4dyGi7h7XJZyJFPhDZ
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11962
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 phishscore=0 bulkscore=10 suspectscore=0 priorityscore=1501
 lowpriorityscore=10 impostorscore=10 malwarescore=0 spamscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611100073

With DIX enabled, blocks written by WRITE SAME or WRITE ATOMIC(16) on
scsi_debug fail the guard check when they are read back. A filesystem
made by mkfs.xfs on a previously formatted device can't be mounted, and
xfstests generic/770 fails on XFS.

The first patch makes WRITE ATOMIC(16) verify and store the protection
information it is sent, like WRITE. The second patch generates
protection information for writes that come without it, such as WRITE
SAME, as a device formatted with protection information does.

This was found while testing the atomic write bounce series [1]. The
fixes were proposed by an LLM.

[1] https://lore.kernel.org/r/20261107-blkdev-atomic-bounce-v1-0-f66344262096@columbia.edu

---
Tal Zussman (2):
      scsi: scsi_debug: handle protection information for WRITE ATOMIC(16)
      scsi: scsi_debug: generate protection information for writes without it

 drivers/scsi/scsi_debug.c | 61 +++++++++++++++++++++++++++++++++++++----------
 1 file changed, 49 insertions(+), 12 deletions(-)
---
base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
change-id: 20261107-scsi-debug-pi-f51019c898a0

Best regards,
--  
Tal Zussman <tz2294@columbia.edu>

