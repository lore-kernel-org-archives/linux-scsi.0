Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8073BC74A44
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Mar 2023 21:49:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231565AbjCGVtP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Mar 2023 16:49:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231576AbjCGVtF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Mar 2023 16:49:05 -0500
Received: from amity.mint.lgbt (vmi888983.contaboserver.net [149.102.157.145])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 135F88EA33
        for <linux-scsi@vger.kernel.org>; Tue,  7 Mar 2023 13:48:59 -0800 (PST)
Received: from amity.mint.lgbt (mx.mint.lgbt [127.0.0.1])
        by amity.mint.lgbt (Postfix) with ESMTP id 4PWTbs4Ysyz1S5Jv
        for <linux-scsi@vger.kernel.org>; Tue,  7 Mar 2023 16:48:57 -0500 (EST)
Authentication-Results: amity.mint.lgbt (amavisd-new);
        dkim=pass (2048-bit key) reason="pass (just generated, assumed good)"
        header.d=mint.lgbt
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mint.lgbt; h=
        content-transfer-encoding:content-type:in-reply-to:from
        :references:to:content-language:subject:user-agent:mime-version
        :date:message-id; s=dkim; t=1678225736; x=1679089737; bh=LBDNRan
        2Cd8nNBtnj8IHxtHFO6mc9pcFTMtM8qGwz6s=; b=jE534R06Hd7fQjg/r3yymW4
        2G/z4O85FngEOuWTYP/K3kQoG/HSExQQ6yrrmRtIc4WSKl/VgHyyJpti+jQ1JeQ9
        eR0Q2JfiIX6Tle48e+vcnKhyHzZmtD4y94qWPnO0w27uLcy9BJKFymUp/X4hPcrK
        ELE/eQD6+E99op2O7rZhK81Q/4YzFsnOuEKb/OIHaXKxtKtAXiWUu6rVi7TSGjbB
        wVUmyZ47+q+GoxRDbLaHWYosKIhK6qDVWhFLbkJl6NbwjXHBMCwCoH8TSXS5bVej
        LDWwpQI/KJOLm7j/B2kicTKYKFsQC1MQJ/L81Uur46ClAzpiq1xyYJzojlIla2g=
        =
X-Virus-Scanned: amavisd-new at amity.mint.lgbt
Received: from amity.mint.lgbt ([127.0.0.1])
        by amity.mint.lgbt (amity.mint.lgbt [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id s5aVeQZCghMY for <linux-scsi@vger.kernel.org>;
        Tue,  7 Mar 2023 16:48:56 -0500 (EST)
Received: from [192.168.1.90] (unknown [186.105.8.42])
        by amity.mint.lgbt (Postfix) with ESMTPSA id 4PWTbS4Kjkz1S4yx;
        Tue,  7 Mar 2023 16:48:35 -0500 (EST)
Message-ID: <18156dee-4fd2-80e5-b04d-c96c267fb615@mint.lgbt>
Date:   Tue, 7 Mar 2023 18:48:30 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v7 1/6] dt-bindings: ufs: qcom: Add SM6125 compatible
 string
Content-Language: en-US, es-CL
To:     Konrad Dybcio <konrad.dybcio@linaro.org>, agross@kernel.org,
        andersson@kernel.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, vkoul@kernel.org,
        kishon@kernel.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        bvanassche@acm.org, keescook@chromium.org, tony.luck@intel.com,
        gpiccoli@igalia.com
Cc:     ~postmarketos/upstreaming@lists.sr.ht,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-scsi@vger.kernel.org, linux-hardening@vger.kernel.org,
        phone-devel@vger.kernel.org, martin.botka@somainline.org,
        marijn.suijten@somainline.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
References: <20230306165246.14782-1-they@mint.lgbt>
 <20230306165246.14782-2-they@mint.lgbt>
 <4670ddae-6b01-1e5c-b0ed-1f2f498a4f66@mint.lgbt>
 <dfd1d81e-76a0-f8eb-e529-9f8ea1e927b6@linaro.org>
From:   Lux Aliaga <they@mint.lgbt>
In-Reply-To: <dfd1d81e-76a0-f8eb-e529-9f8ea1e927b6@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/6/2023 14:09, Konrad Dybcio wrote:

>
> On 6.03.2023 18:01, Lux Aliaga wrote:
>> On 06/03/2023 13:52, Lux Aliaga wrote:
>>> Document the compatible for UFS found on the SM6125.
>>>
>>> Signed-off-by: Lux Aliaga <they@mint.lgbt>
>>> Reviewed-by: Martin Botka <martin.botka@somainline.org>
>>> Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>>> ---
>>>  =C2=A0 Documentation/devicetree/bindings/ufs/qcom,ufs.yaml | 2 ++
>>>  =C2=A0 1 file changed, 2 insertions(+)
>>>
>>> diff --git a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml b/Do=
cumentation/devicetree/bindings/ufs/qcom,ufs.yaml
>>> index b517d76215e3..42422f3471b3 100644
>>> --- a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
>>> +++ b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
>>> @@ -29,6 +29,7 @@ properties:
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 -=
 qcom,sc8280xp-ufshc
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 -=
 qcom,sdm845-ufshc
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 -=
 qcom,sm6115-ufshc
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 - qcom,sm6125=
-ufshc
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 -=
 qcom,sm6350-ufshc
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 -=
 qcom,sm8150-ufshc
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 -=
 qcom,sm8250-ufshc
>>> @@ -185,6 +186,7 @@ allOf:
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 c=
ontains:
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 enum:
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 - qcom,sm6115-ufshc
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 - qcom,sm6125-ufshc
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 then:
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 properties:
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 clocks:
>> I have to apologize. I worked on a changelog for this patchset but I s=
kipped the subject header, therefore it didn't send, and as I realized th=
is I interrupted the process, leaving the patchset incomplete. I'll retry=
 sending it, this time correctly.
> Happens, next time resend it with a RESEND prefix, e.g. [RESEND PATCH 1=
/2]
>
> Konrad

Thank you! Will take this into consideration for the future. I received=20
this email after I resent the patchset, so that's why I didn't add the=20
prefix.

--=20
Lux Aliaga
https://nixgoat.me/

