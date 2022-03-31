Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B732DC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Mar 2022 16:22:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239838AbiCaQYE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Mar 2022 12:24:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233788AbiCaQYD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2022 12:24:03 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D22C4EA33
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 09:22:16 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id m30so547711wrb.1
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 09:22:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:from:to:subject
         :content-transfer-encoding;
        bh=SNHHRe2ZzSNGPseirROJTlFiRpkfoRkugNhNQv1nRKk=;
        b=LSyHRyCjC8kF2nS7CMi0krzzcgkCQHrglcbA2aivzOkGRYN5LBGZ+nbBj6vP2Yzt+4
         mAnuXQeACn8Vn9OLrW5Tfb1X0DZ3iMaFQnDIwtJQzcdmHh+wAOxhx6yio0XM3URut7jw
         2f7balDWUPK+dM35VV/YgY+j6Qhxhr963Ud0NGNac3amNZFWEpbslP6ZFcN88hJOfVm6
         OI6bXAOSbkUPFl94eg56ij7NXHuqKnDYoPBeJPWbTgnuBvCtZWVE5czNWD1RlY5TQuz5
         mCX8tEwEMkqKZbi4BYeJq+GRpCeUtWnxvu4xHT/Zfc54za3aJ/Y0Y3GrghpXlB1xuvHG
         we4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:from:to:subject
         :content-transfer-encoding;
        bh=SNHHRe2ZzSNGPseirROJTlFiRpkfoRkugNhNQv1nRKk=;
        b=TQsIxL2kuxvzYXRqV4R7a2zBn8iChkZ+M2AUTxu0a9QpTGmLQnmxgqKhBJN3kVjoge
         nSiO6IN3ev0KWDhc2V9MrJiJiINdGLl2imtVYqbR12fowSCgg7TXVMMj12IBU24ecxDV
         J2Ky6+oQKer4oPUchVXTXOdnc6SYIQMqPDPVWE9vuYBD9+cTz2OhpwT+MYptMGrpdVkE
         9g5TXpNkwJ7XnOzvjnVabVe6Kt8JRQsO7cPq435PGlghj4oCq63PHoho5+3KiMAVajeH
         IiFkUUgoZmrlzZDGJrHPBQ6dCDj//HllISJd5JZTjhw2/XF1j+O6k7jXzHr76FwQh28u
         tfRQ==
X-Gm-Message-State: AOAM532T9iBCXfHCAgDn/wph1Q9G88XPiPBA+lT2fOdZzzvOVRFyUD1B
        stKBteySBxmdrQlKH+EhyPuN2BGcEqwdPw==
X-Google-Smtp-Source: ABdhPJxHIwXmOus/XrHfCbs5QwYOfvNiE7UovqqJrevpLvXJ2ouvP7jsweLVdtEAgqmNNObyrebfjw==
X-Received: by 2002:a5d:6c68:0:b0:205:a0ee:c871 with SMTP id r8-20020a5d6c68000000b00205a0eec871mr4627667wrz.526.1648743734663;
        Thu, 31 Mar 2022 09:22:14 -0700 (PDT)
Received: from DESKTOP-R5VBAL5 ([39.53.224.185])
        by smtp.gmail.com with ESMTPSA id o5-20020a5d4a85000000b00205a8bb9c0dsm22031841wrq.90.2022.03.31.09.22.13
        for <linux-scsi@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Thu, 31 Mar 2022 09:22:14 -0700 (PDT)
Message-ID: <6245d536.1c69fb81.54962.6538@mx.google.com>
Date:   Thu, 31 Mar 2022 09:22:14 -0700 (PDT)
X-Google-Original-Date: 31 Mar 2022 12:22:13 -0400
MIME-Version: 1.0
From:   nickolasdreamlandestimation@gmail.com
To:     linux-scsi@vger.kernel.org
Subject: Estimating Services
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,=0D=0A=0D=0AWe provide estimation & quantities takeoff service=
s. We are providing 98-100 accuracy in our estimates and take-off=
s. Please tell us if you need any estimating services regarding y=
our projects.=0D=0A=0D=0ASend over the plans and mention the exac=
t scope of work and shortly we will get back with a proposal on w=
hich our charges and turnaround time will be mentioned=0D=0A=0D=0A=
You may ask for sample estimates and take-offs. Thanks.=0D=0A=0D=0A=
Kind Regards=0D=0ANickolas Casas=0D=0ADreamland Estimation, LLC

