From: "Bryan Henderson" <hbryan@us.ibm.com>
Subject: Re: st.c block limits
Date: Thu, 1 Aug 2002 09:06:07 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OFF932D526.D3790AFD-ON87256C08.00583CFD@boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Cc: 'ael' <law_ence.dev@ntlworld.com>, linux-scsi@vger.kernel.org, Tony Battersby <tonyb@cybernetics.com>


>It's easy to prevent this from costing too much: Simply prepend a
>block of data with a "1" compressed or "0" uncompressed bit.
>
>Max expansion is then 1 bit per block. (At a cost of one extra bit per
>block).

Could you elaborate on this?  What does "'1' compressed or '0' uncompressed
bit" mean?  Where exactly do you do this prepending?  Is this according to
some protocol that has a name?



