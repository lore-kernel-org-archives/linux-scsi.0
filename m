Received: from pv50p00im-zteg10021301.me.com (pv50p00im-zteg10021301.me.com [17.58.6.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08623218852
	for <linux-scsi@vger.kernel.org>; Thu,  5 Dec 2024 13:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=17.58.6.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733405991; cv=none; b=hH0MIE0bbsaXIC2u/AXh0zzavF4OjSfMxlPqbkuGIZ9bza9mul75TwdaaRphmLYypgqXVeAO+nkKR/dbz9zoUbsNcd4apKQSGI6235tIP1w1rVEmAkwyLMxK7+y2v8M+UzIEG6BLZ0GX3Hxlrs6+QANEzSP+RnghK+mLiuqmksA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733405991; c=relaxed/simple;
	bh=w+L/ijIwxtCjBnjeF2BOoaJY0nsNF0I+MjgrNIZmI/E=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=JHIMiXE183EdxmngWm1U2LIWe0pCKI/ZqpLb+6oREJsoPBAFqqfy5L/lQTPW+YHw3bjfBzGFkGpgdjj+eBWnVsqMgkp2KcKGZAZcHwvZXQzxIK3D0LUU7DkptqiW2ueyz8szcWxV+aYlK8MAcm96neVd2jNQPZFb9IpheWDhCug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com; spf=pass smtp.mailfrom=icloud.com; dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b=Z6ptqCKB; arc=none smtp.client-ip=17.58.6.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=icloud.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b="Z6ptqCKB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
	s=1a1hai; t=1733405989;
	bh=EGaT1YDpM3YHyk2JGIqu5Mj6uAzoCxkX7HHojx+Nakw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:
	 x-icloud-hme;
	b=Z6ptqCKB8VbbMOxA3C2zdd27e4pyc841ODJECqWb4IybLv6WmFqLzgUY49mCwb+zY
	 bUQWK+0uA1eZKMdsykc82oUvX7wvM5sY2iPB93t6z6wae9/g5Xc4NEcnNFTwwSJEnS
	 NdPLaV5wSoSL8fawCOx+k5OgaqeCUeHQ3pMj9Diwtc0wvv3CCyeVgYnNvipbI6R8g7
	 4oAOzj2yMJGRmX5JnI+r/tdARog3N7UkYkumD+8tobk3h56WTzVe9bljFte184afcJ
	 vv3nnMNtpJ3dHMp1OHMiWq3xIMsVmKFkQRgXgK7jFEgcLKFRnQgSuUvsMS3JwuDn0z
	 ayCVCmZqzn12A==
Received: from [192.168.1.26] (pv50p00im-dlb-asmtp-mailmevip.me.com [17.56.9.10])
	by pv50p00im-zteg10021301.me.com (Postfix) with ESMTPSA id E5E225000BE;
	Thu,  5 Dec 2024 13:39:46 +0000 (UTC)
From: Zijun Hu <zijun_hu@icloud.com>
Date: Thu, 05 Dec 2024 21:39:22 +0800
Subject: [PATCH] MAINTAINERS: Remove open-iscsi@googlegroups.com
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241205-remove_iscsi_group-v1-1-890ee8484978@quicinc.com>
X-B4-Tracking: v=1; b=H4sIAAmtUWcC/x3MQQqAIBBA0avErBPUMqqrRETUaLMoY4YkiO6et
 HyL/x8QZEKBvniAMZFQPDJMWcCyzUdARWs2WG1rY7VTjHtMOJEsQlPgeJ2qc9qbZm4r52vI4cn
 o6f6nw/i+HymhhdtkAAAA
X-Change-ID: 20241205-remove_iscsi_group-950f16a835f4
To: Zijun Hu <zijun_hu@icloud.com>, linux-scsi@vger.kernel.org, 
 linux-kernel@vger.kernel.org
Cc: Zijun Hu <quic_zijuhu@quicinc.com>
X-Mailer: b4 0.14.2
X-Proofpoint-GUID: vmZ35Z26o7HxTXn3aJvdxYPTEpY_yAdH
X-Proofpoint-ORIG-GUID: vmZ35Z26o7HxTXn3aJvdxYPTEpY_yAdH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-05_11,2024-12-05_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 suspectscore=0
 mlxlogscore=890 adultscore=0 malwarescore=0 phishscore=0 mlxscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2308100000 definitions=main-2412050098
X-Apple-Remote-Links: v=1;h=KCk=;charset=UTF-8

From: Zijun Hu <quic_zijuhu@quicinc.com>

There are always erroneous response when send mail to
open-iscsi@googlegroups.com.

Remove that unreachable address.

Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1e930c7a58b13d8bbe6bf133ba7b36aa24c2b5e0..1c203d335c8d3e76ea2683996e9804999e4a4d53 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12175,7 +12175,6 @@ ISCSI
 M:	Lee Duncan <lduncan@suse.com>
 M:	Chris Leech <cleech@redhat.com>
 M:	Mike Christie <michael.christie@oracle.com>
-L:	open-iscsi@googlegroups.com
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
 W:	www.open-iscsi.com

---
base-commit: feffde684ac29a3b7aec82d2df850fbdbdee55e4
change-id: 20241205-remove_iscsi_group-950f16a835f4

Best regards,
-- 
Zijun Hu <quic_zijuhu@quicinc.com>

